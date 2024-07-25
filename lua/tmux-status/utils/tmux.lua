-- Other useful commands for getting info out of tmux
-- list-windows
-- display-message

local split = require('tmux-status.utils.str').split

local M = {}

---@type string?
M._USER = nil

---@type string[]?
M._windows = nil

---@type string?
M._session = nil

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
      "#{s|^" .. M._USER .. "|~|:#{b:pane_current_path}}#{s/!/ " .. opts.icon_bell .. "/:#{s/~/ " .. opts.icon_mute .. "/:#{s/M/ " .. opts.icon_mark .. "/:#{s/Z/ " .. opts.icon_zoom .. "/:#{s/#/ " .. opts.icon_activity .. "/:window_flags}}}}}",
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

---comment
---@return boolean
function M.is_status_off()
  local output = vim.system({
    'tmux',
    'show-options',
    '-gv',
    'status'
  }, { text = true }):wait()

  -- return output.stdout:find('off')
  return string.find(output.stdout, 'off') and true or false
end

return M
