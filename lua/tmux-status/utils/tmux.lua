-- TODO: use `tmux show -g @component` instead so the exact same component can be shared

-- Other useful commands for getting info out of tmux
-- list-windows
-- display-message

local split = require('tmux-status.utils.str').split

---@type table<"dir"|"name", string>
local text_map = {
  dir = "b:pane_current_path",
  name = "window_name",
}

local M = {}

---@type string?
M._USER = nil

---@type string[]?
M._windows = nil

---@type string?
M._session = nil

---@type string?
M._datetime = nil

---@type string?
M._battery = nil

---Whether we're inside a tmux session or not
---@return boolean
function M.is_tmux()
  return vim.fn.has_key(vim.fn.environ(), 'TMUX') and true or false
end

---Get a list of window names with their flags replaced for the correct icons
---@param opts TmuxStatusComponentWindow
---@return string[]
function M.list_windows(opts)
  if not M._USER then
    M._USER = vim.fn.environ().USER
  end

  vim.system(
    {
      'tmux',
      'list-windows',
      '-F',
      "#{s|^" .. M._USER .. "|~|:#{" .. text_map[opts.text] .. "}}#{s/!/ " .. opts.icon_bell .. "/:#{s/~/ " .. opts.icon_mute .. "/:#{s/M/ " .. opts.icon_mark .. "/:#{s/Z/ " .. opts.icon_zoom .. "/:#{s/#/ " .. opts.icon_activity .. "/:window_flags}}}}}",
    },
    { text = true },
    function (output)
      M._windows = split(output.stdout, "[^\r\n]+")
    end
  )

  return M._windows
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
      M._session = obj.stdout:gsub("[\n\r]", '')
    end
  )

  return M._session
end

---@param opts TmuxStatusComponentDatetime
---@return string
function M.get_datetime(opts)
  vim.system(
    { 'date', "+" .. opts.format },
    { text = true },
    function (out)
        M._datetime = out.stdout:gsub("[\n\r]", '')
    end
  )

  return M._datetime
end

---@return string
function M.get_battery()
  vim.system(
    -- { 'pmset', '-g', 'batt', '|', 'awk', '{print $3}', '|', 'sed', '\'s/;//\'' },
    -- { 'pmset', '-g', 'batt', '|', 'awk', '{print $3}' },
    { 'tmux', 'show', '-gv', '@c_battery' },
    { text = true },
    function (out)
        M._battery = out.stdout:gsub("[\n\r]", '')
    end
  )

  -- vim.o.cmdheight=1
  -- print(M._battery)
  -- return "Foo"

  return M._battery
end
---Whether Tmux status is set to off
---@return boolean
function M.is_status_off()
  --PERF async
  local output = vim.system({
    'tmux',
    'show',
    '-v',
    'status'
  }, { text = true }):wait()

  return string.find(output.stdout, 'off') and true or false
end

return M
