local M = {}

---@param opts TmuxStatusComponentDatetime
---@return string
function M.get_tmux_datetime(opts)
  local datetime = require('tmux-status.utils.tmux').get_datetime(opts)

  return require('tmux-status.highlights').get_highlight('tmux_status_datetime') .. opts.icon .. " " .. datetime
end

return M
