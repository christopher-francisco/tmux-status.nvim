local M = {}

---@param colors TmuxStatusComponentColors
function M.create_hightlights(colors)
  vim.cmd.highlight('tmux_status_window_active guifg=' .. colors.window_active)
  vim.cmd.highlight('tmux_status_window_inactive guifg=' .. colors.window_inactive)
  vim.cmd.highlight('tmux_status_window_inactive_recent guifg=' .. colors.window_inactive_recent)
  vim.cmd.highlight('tmux_status_session guifg=' .. colors.session)
end

return M
