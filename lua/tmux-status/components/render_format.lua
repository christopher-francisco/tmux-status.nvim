local M = {}

---@param name string
---@return string
function M.render_format(name)
  return require('tmux-status.utils.tmux').render_format(name, name)
end

return M
