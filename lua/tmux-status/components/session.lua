local M = {}

---@param opts TmuxStatusComponentSession
---@return string
function M.get_tmux_session(opts)
  local session = require('tmux-status.utils.tmux').get_session()

  return "%#tmux_status_session#" .. opts.icon .. " " .. session
end

return M
