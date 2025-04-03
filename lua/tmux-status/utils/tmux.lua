local split = require('tmux-status.utils.str').split

---@type table<"dir"|"name", string>
local text_map = {
  dir = "b:pane_current_path",
  name = "window_name",
  index_and_name = "#{}#I:#W",
}

local M = {}

M._async_cache = {}

---@type boolean We 
M._async_cache.status_off = true

---@type string?
M._async_cache.USER = nil

---@type string[]?
M._async_cache.windows = nil

---@type string?
M._async_cache.session = nil

---@type string?
M._async_cache.datetime = nil

---@type string?
M._async_cache.battery = nil

---@type table<string, string?>
M._async_cache.rendered = {}

---Escape characters that can break statusline
---@param str string
---@return string
local function escape(str)
  -- Yep, it takes 4 %s to escape it properly
  return str:gsub("%%", "%%%%") or "[error]"
end

---Remove \r\n
---@param str string
---@return string
local function remove_newline(str)
  return str:gsub("[\n\r]", '') or "[error]"
end

---Whether we're inside a tmux session or not
---@return boolean
function M.is_tmux()
  return vim.fn.has_key(vim.fn.environ(), 'TMUX') == 1
end


---@param format string
---@param cache_key string
---@return string
function M.render_format(format, cache_key)
  vim.system(
    {
      'tmux',
      'display-message',
      '-p',
      '#{' .. format .. '}',
    },
    { text = true },
    function (out)
      M._async_cache.rendered[cache_key] = remove_newline(escape(out.stdout))
    end
  )

  return M._async_cache.rendered[cache_key]
end

---Get a list of window names with their flags replaced for the correct icons
---@param opts TmuxStatusComponentWindow
---@return string[]
function M.list_windows(opts)
  if not M._async_cache.USER then
    M._async_cache.USER = vim.fn.environ().USER
  end

  vim.system(
    {
      'tmux',
      'list-windows',
      '-F',
      "#{s|^" .. M._async_cache.USER .. "|~|:#{" .. text_map[opts.text] .. "}}#{s/!/ " .. opts.icon_bell .. "/:#{s/~/ " .. opts.icon_mute .. "/:#{s/M/ " .. opts.icon_mark .. "/:#{s/Z/ " .. opts.icon_zoom .. "/:#{s/#/ " .. opts.icon_activity .. "/:window_flags}}}}}",
    },
    { text = true },
    function (output)
      M._async_cache.windows = split(output.stdout, "[^\r\n]+")
    end
  )

  return M._async_cache.windows
end

function M.get_session()
  vim.system(
    {
      'tmux',
      'display-message',
      '-p',
      '#S',
    },
    { text = true },
    function(obj)
      M._async_cache.session = obj.stdout:gsub("[\n\r]", '')
    end
  )

  return M._async_cache.session
end

---@param opts TmuxStatusComponentDatetime
---@return string
function M.get_datetime(opts)
  vim.system(
    { 'date', "+" .. opts.format },
    { text = true },
    function (out)
        M._async_cache.datetime = out.stdout:gsub("[\n\r]", '')
    end
  )

  return M._async_cache.datetime
end

---@return string
function M.get_battery()
  vim.system(
    { 'pmset', '-g', 'batt' },
    { text = true },
    function (out)
      local _, _, batt = out.stdout:find("(%d+%%)")

       M._async_cache.battery = remove_newline(escape(batt))
    end
  )

  return M._async_cache.battery
end

---Whether Tmux status is set to off
---@return boolean
function M.is_status_off()
  vim.system(
    {
      'tmux',
      'show',
      '-v',
      'status'
    },
    { text = true },
    function (out)
      M._async_cache.status_off = out.stdout:find('off') and true or false
    end
  )

  return M._async_cache.status_off
end

return M
