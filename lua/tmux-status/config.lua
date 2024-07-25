---@class TmuxStatusComponentColors
---@field window_active string
---@field window_inactive string
---@field window_inactive_recent string
---@field session string

---@class TmuxStatusComponentWindow
---@field separator string
---@field icon_zoom string
---@field icon_mark string
---@field icon_bell string
---@field icon_mute string
---@field icon_activity string

---@class TmuxStatusComponentSession
---@field icon string

---@class TmuxStatusOptions
---@field window TmuxStatusComponentWindow
---@field session TmuxStatusComponentSession
---@field colors TmuxStatusComponentColors
---@field force_show boolean Show tmux-status components even if Tmux status is `on`
---@field manage_tmux_status boolean

local M = {}

---@type TmuxStatusOptions
M.default_options = {
  window = {
    separator = "   ",
    icon_zoom = "",
    icon_mark = "",
    icon_bell = "",
    icon_mute = "",
    icon_activity = "",
  },
  session = {
    icon = ""
  },
  colors = {
    window_active = "#e69875",
    window_inactive = "#859289",
    window_inactive_recent = "#3f5865",
    session = "#a7c080",
  },
  force_show = false,
  manage_tmux_status = true,
}

return M
