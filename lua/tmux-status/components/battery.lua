local M = {}

---@param opts TmuxStatusComponentBattery
---@return string
function M.get_tmux_battery(opts)
  local battery = require('tmux-status.utils.tmux').get_battery()

  return require('tmux-status.highlights').get_highlight('tmux_status_battery') .. opts.icon .. " " .. battery
end

return M
