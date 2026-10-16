local M = {}

---A color is either a foreground (`"#e69875"`) or a table with `fg` and/or `bg`
---@param value string|table
---@return vim.api.keyset.highlight
local function to_highlight(value)
  if type(value) == "string" then
    return { fg = value }
  end

  return { fg = value.fg, bg = value.bg }
end

---@param colors TmuxStatusComponentColors|fun(): TmuxStatusComponentColors
local function set_highlights(colors)
  if type(colors) == "function" then
    colors = colors()
  end

  for name, value in pairs(colors) do
    vim.api.nvim_set_hl(0, "tmux_status_" .. name, to_highlight(value))
  end
end

---Sets the highlights now, and again after every colorscheme change (`:colorscheme` clears them).
---A function is called each time, so the colors can follow the colorscheme.
---@param colors TmuxStatusComponentColors|fun(): TmuxStatusComponentColors
function M.create_hightlights(colors)
  set_highlights(colors)

  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    pattern = "*",
    callback = function()
      set_highlights(colors)
    end,
  })
end

---@param name string
---@return string
function M.get_highlight(name)
  return "%#" .. name .. "#"
end

return M
