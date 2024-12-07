local M = {}

---@param colors TmuxStatusComponentColors
function M.create_hightlights(colors)
  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    pattern = "*",
    callback = function()
      for name, value in pairs(colors) do
        vim.cmd.highlight("tmux_status_" .. name .. " guifg=" .. value.fg .. " guibg=" .. value.bg)
      end
    end,
  })
end

---@param name string
---@return string
function M.get_highlight(name)
  return "%#" .. name .. "#"
end

return M
