local M = {}

---Add highlights depending on the window flag. Swaps the flag character for the highlight
---@param windows string[]
---@return string[]
local function add_windows_highlights(windows)
  ---@type string[]
  local formatted_windows = {}

  for _, window in ipairs(windows) do
    local formatted_window = window

    if string.find(window, '*') then
      formatted_window = "%#tmux_status_window_active#" .. window:gsub('*', '')
    elseif string.find(window, '-') then
      formatted_window = "%#tmux_status_window_inactive_recent#" .. window:gsub('-', '')
    else
      formatted_window = "%#tmux_status_window_inactive#" .. window
    end

    table.insert(formatted_windows, formatted_window)
  end

  return formatted_windows
end

---Get an array of tmux windows with replaced flags for unicode characters
---@param opts TmuxStatusComponentWindow
---@return string
function M.get_tmux_windows(opts)
  local windows = require('tmux-status.utils.tmux').list_windows(opts)

  local highlighted_windows = add_windows_highlights(windows)

  return table.concat(highlighted_windows, opts.separator)
end

return M
