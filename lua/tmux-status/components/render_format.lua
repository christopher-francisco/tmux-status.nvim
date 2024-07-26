local M = {}

function M.render_format(name)
  require('tmux-status.utils.tmux').render_format(name, name)
end

return M
