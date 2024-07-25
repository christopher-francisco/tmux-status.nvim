local M = {}

-- TODO: do these
  -- create autocmds to status off/on on following events
  -- vimenter
  -- vimleave
  -- if there's only 1 pane in the window 
  -- or if pane is zoomed in
  -- pane zommed in
  -- pane zommed out


local function status_off()
  vim.system({ 'tmux', 'set', 'status', 'off' }, {}, function () end)
end

local function status_on()
  vim.system({ 'tmux', 'set', 'status', 'on' }, {}, function () end)
end

---@param event string|string[] see `:h events`
---@param desc string
---@param callback function
local function create_autocmd(event, desc, callback)
  vim.api.nvim_create_autocmd(event, {
    desc = desc,
    callback = callback
  })
end

---@param event string|string[]
local function create_on_autocmd(event)
  create_autocmd(event, "Restore tmux status", status_on)
end

---@param event string|string[]
local function create_off_autocmd(event)
  create_autocmd(event, "Hides tmux status", status_off)
end

---@param enabled boolean
function M.register(enabled)
  if not enabled then
    return
  end

  status_off()

  create_on_autocmd({ "VimLeavePre", "FocusLost" })
  create_off_autocmd("FocusGained")

end

return M
