---@class TmuxStatusComponentColors
---@field window_active string
---@field window_inactive string
---@field window_inactive_recent string
---@field session string
---@field datetime string
---@field battery string

---@class TmuxStatusComponentWindow
---@field separator string
---@field icon_zoom string
---@field icon_mark string
---@field icon_bell string
---@field icon_mute string
---@field icon_activity string
---@field text "dir"|"name"

---@class TmuxStatusComponentSession
---@field icon string

---@class TmuxStatusComponentDatetime
---@field icon string
---@field format string

---@class TmuxStatusComponentBattery
---@field icon string

---@class TmuxStatusOptions
---@field window TmuxStatusComponentWindow
---@field session TmuxStatusComponentSession
---@field datetime TmuxStatusComponentDatetime
---@field battery TmuxStatusComponentBattery
---@field colors TmuxStatusComponentColors
---@field force_show boolean Show tmux-status components even if Tmux status is `on`
---@field manage_tmux_status boolean

local M = {}

---@type TmuxStatusOptions
M.default_options = {
  window = {
    separator = "  ",
    icon_zoom = "",
    icon_mark = "",
    icon_bell = "",
    icon_mute = "",
    icon_activity = "",
    text = "dir"
  },
  session = {
    icon = ""
  },
  datetime = {
    icon = "󱑍",
    format = "%a %d %b %k:%M",
  },
  battery = {
    icon = "󰂎",
  },
  colors = {
    window_active = "#e69875",
    window_inactive = "#859289",
    window_inactive_recent = "#3f5865",
    session = "#a7c080",
    datetime = "#7a8478",
    battery = "#7a8478",
  },
  force_show = false,
  manage_tmux_status = true,
}

return M
