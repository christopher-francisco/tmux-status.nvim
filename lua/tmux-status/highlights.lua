local M = {}

---@param colors TmuxStatusComponentColors
function M.create_hightlights(colors)
  for name, value in pairs(colors) do
    vim.cmd.highlight('tmux_status_' .. name .. ' guifg=' .. value)
  end
end

---@param name string
---@return string
function M.get_highlight(name)
  return "%#" .. name .. "#"
end

return M
