local is_tmux = require('tmux-status.utils.tmux').is_tmux
local is_status_off = require('tmux-status.utils.tmux').is_status_off

local M = {}

---This controls whether the components should be shown given
---the status of the tmux pane
--- * 1 pane: true
--- * 1+ panes: true if zoomed
--- * false when entering vim
--- * true when leaving, or unfocusing vim
---@type boolean
M._show = true

---@type TmuxStatusOptions
M._config = require('tmux-status.config').default_options

local function get_error_message()
  return "Not within tmux"
end

---@param opts TmuxStatusOptions
function M.setup(opts)
  M._config = vim.tbl_deep_extend('force', M._config, opts)

  require('tmux-status.autocmds').register(M._config.manage_tmux_status)
  require('tmux-status.highlights').create_hightlights(M._config.colors)
end

function M.show()
  -- local should_show = is_status_off() or M._config.force_show
  local should_show = (is_status_off() and M._show) or M._config.force_show

  return is_tmux() and should_show
end

---Lualine component
---@return string
function M.tmux_windows()
  if not is_tmux() then
    return get_error_message()
  end

  return require('tmux-status.components.windows').get_tmux_windows(M._config.window)
end

function M.tmux_session()
  if not is_tmux() then
    return get_error_message()
  end

  return require('tmux-status.components.session').get_tmux_session(M._config.session)
end

function M.tmux_datetime()
  if not is_tmux() then
    return get_error_message()
  end

  return require('tmux-status.components.datetime').get_tmux_datetime(M._config.datetime)
end

function M.tmux_battery()
  if not is_tmux() then
    return get_error_message()
  end

  return require('tmux-status.components.battery').get_tmux_battery(M._config.battery)
end

return M
