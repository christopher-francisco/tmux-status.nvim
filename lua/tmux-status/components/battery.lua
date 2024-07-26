local M = {}

---@param opts TmuxStatusComponentBattery
---@return string
function M.get_tmux_battery(opts)
  local battery = require('tmux-status.utils.tmux').get_battery()

  -- TODO: maybe rename "icon" for "prefix"?
  -- And let consumer add their own highlight to the prefix?
  -- kinda like prefix = "%#custom_bg #%#custom_fg#󰂎 %#custom_bg"
  return require('tmux-status.highlights').get_highlight('tmux_status_battery') .. opts.icon .. " " .. battery
end

return M
