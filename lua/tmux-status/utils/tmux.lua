local split = require('tmux-status.utils.str').split

local function table_contains_key(table, element)
  for key, _ in pairs(table) do
    if key == element then
      return true
    end
  end
  return false
end

---@type table<"dir"|"name"|"index_and_name", string>
local text_map = {
  dir = "b:pane_current_path",
  name = "window_name",
  index_and_name = "#{}#I:#W",
}

---Separates the values of the single `display-message` call
local SEPARATOR = "<<tmux-status>>"

local M = {}

---Getters only read this cache. A poller (see `M.start`) fills it on a timer, so drawing the
---statusline never spawns a process.
M._async_cache = {}

---@type boolean
M._async_cache.status_off = true

---@type string?
M._async_cache.USER = nil

---@type string[]?
M._async_cache.windows = nil

---@type string?
M._async_cache.session = nil

---@type string?
M._async_cache.battery = nil

---@type table<string, string?>
M._async_cache.rendered = {}

---What the getters asked for, so the poller only runs what is used
M._wanted = {
  ---@type string? `list-windows -F` format
  windows = nil,
  battery = false,
  ---@type table<string, string> cache key -> tmux format
  rendered = {},
}

---Commands still running, so a slow tmux never piles up processes
---@type table<string, boolean>
M._running = {}

---@type uv.uv_timer_t?
M._timer = nil

---@type uv.uv_timer_t?
M._battery_timer = nil

---Escape characters that can break statusline
---@param str string
---@return string
local function escape(str)
  -- Yep, it takes 4 %s to escape it properly
  return str:gsub("%%", "%%%%") or "[error]"
end

---Remove \r\n
---@param str string
---@return string
local function remove_newline(str)
  return str:gsub("[\n\r]", '') or "[error]"
end

---Whether we're inside a tmux session or not
---@return boolean
function M.is_tmux()
  return vim.fn.has_key(vim.fn.environ(), 'TMUX') == 1
end

---Run a command unless the previous run of the same `name` is still going. Never raises: a
---failed spawn (e.g. EMFILE) or a failed command keeps the previous cached value.
---@param name string
---@param cmd string[]
---@param on_stdout fun(stdout: string)
local function run(name, cmd, on_stdout)
  if M._running[name] then
    return
  end
  M._running[name] = true

  local ok = pcall(vim.system, cmd, { text = true }, function(out)
    M._running[name] = nil
    if out.code == 0 and out.stdout then
      pcall(on_stdout, out.stdout)
    end
  end)

  if not ok then
    M._running[name] = nil
  end
end

---Refresh status, session, rendered formats and windows: two tmux calls at most
function M.poll()
  local keys = {}
  local formats = { "#{status}", "#S" }
  for key, format in pairs(M._wanted.rendered) do
    table.insert(keys, key)
    table.insert(formats, "#{" .. format .. "}")
  end

  run('display', { 'tmux', 'display-message', '-p', table.concat(formats, SEPARATOR) }, function(stdout)
    local values = vim.split(remove_newline(stdout), SEPARATOR, { plain = true })
    M._async_cache.status_off = values[1] == "off"
    M._async_cache.session = values[2]
    for i, key in ipairs(keys) do
      M._async_cache.rendered[key] = escape(values[i + 2] or "")
    end
  end)

  if M._wanted.windows then
    run('windows', { 'tmux', 'list-windows', '-F', M._wanted.windows }, function(stdout)
      M._async_cache.windows = split(stdout, "[^\r\n]+")
    end)
  end
end

function M.poll_battery()
  if not M._wanted.battery then
    return
  end

  run('battery', { 'pmset', '-g', 'batt' }, function(stdout)
    local _, _, batt = stdout:find("(%d+%%)")
    if batt then
      M._async_cache.battery = escape(batt)
    end
  end)
end

---Start the poller (once, and only inside tmux). Called by `setup()` and by the getters, so it
---also works without `setup()`.
function M.start()
  if M._timer or not M.is_tmux() then
    return
  end

  local config = require('tmux-status')._config

  M._timer = vim.uv.new_timer()
  M._timer:start(0, config.poll_interval, vim.schedule_wrap(M.poll))

  M._battery_timer = vim.uv.new_timer()
  M._battery_timer:start(0, config.battery_interval, vim.schedule_wrap(M.poll_battery))

  vim.api.nvim_create_autocmd("VimLeavePre", {
    desc = "Stop tmux-status poller",
    callback = M.stop,
  })
end

function M.stop()
  for _, name in ipairs({ '_timer', '_battery_timer' }) do
    local timer = M[name]
    if timer and not timer:is_closing() then
      timer:stop()
      timer:close()
    end
    M[name] = nil
  end
end

---@param format string
---@param cache_key string
---@return string
function M.render_format(format, cache_key)
  if not M._wanted.rendered[cache_key] then
    M._wanted.rendered[cache_key] = format
    M.start()
    M.poll()
  end

  return M._async_cache.rendered[cache_key] or ""
end

---Get a list of window names with their flags replaced for the correct icons
---@param opts TmuxStatusComponentWindow
---@return string[]
function M.list_windows(opts)
  if not M._wanted.windows then
    if not M._async_cache.USER then
      M._async_cache.USER = vim.fn.environ().USER
    end

    ---@type string
    local format_string = opts.text
    if table_contains_key(text_map, opts.text) then
      format_string = text_map[opts.text]
    end

    M._wanted.windows = "#{s|^" .. M._async_cache.USER .. "|~|:#{" .. format_string .. "}}#{s/!/ " .. opts.icon_bell .. "/:#{s/~/ " .. opts.icon_mute .. "/:#{s/M/ " .. opts.icon_mark .. "/:#{s/Z/ " .. opts.icon_zoom .. "/:#{s/#/ " .. opts.icon_activity .. "/:window_flags}}}}}"
    M.start()
    M.poll()
  end

  return M._async_cache.windows or {}
end

---@return string
function M.get_session()
  M.start()
  return M._async_cache.session or ""
end

---@param opts TmuxStatusComponentDatetime
---@return string
function M.get_datetime(opts)
  return remove_newline(escape(os.date(opts.format) --[[@as string]]))
end

---@return string
function M.get_battery()
  if not M._wanted.battery then
    M._wanted.battery = true
    M.start()
    M.poll_battery()
  end

  return M._async_cache.battery or ""
end

---Whether Tmux status is set to off
---@return boolean
function M.is_status_off()
  M.start()
  return M._async_cache.status_off
end

return M
