local M = {}

---Set tmux's status, then read it back at once so `show()` doesn't wait for the next poll
---@param value "on"|"off"
local function set_status(value)
  pcall(vim.system, { 'tmux', 'set', 'status', value }, {}, vim.schedule_wrap(function()
    if vim.v.exiting == vim.NIL then
      require('tmux-status.utils.tmux').poll()
    end
  end))
end

local function status_off()
  set_status('off')
end

local function status_on()
  set_status('on')
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
  create_off_autocmd({ "FocusGained", "VimResume" })

  create_on_autocmd({ "VimLeavePre", "FocusLost", "VimSuspend" })
end

return M
