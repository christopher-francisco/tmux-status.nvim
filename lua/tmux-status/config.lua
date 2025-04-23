---@class TmuxStatusComponentColors
---@field window_active table
---@field window_inactive table
---@field window_inactive_recent table
---@field session table
---@field datetime table
---@field battery table

---@class TmuxStatusComponentWindow
---@field separator string
---@field icon_zoom string
---@field icon_mark string
---@field icon_bell string
---@field icon_mute string
---@field icon_activity string
---@field text "dir"|"name"|"index_and_name"

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
    text = "dir",
  },
  session = {
    icon = "",
  },
  datetime = {
    icon = "󱑍",
    format = "%a %d %b %k:%M",
  },
  battery = {
    icon = "󰂎",
  },
  colors = {
    window_active = {
      fg = "#e69875",
      bg = "#1F2430",
    },
    window_inactive = {
      fg = "#859289",
      bg = "#1F2430",
    },
    window_inactive_recent = {
      fg = "#3f5865",
      bg = "#1F2430",
    },
    session = {
      fg = "#a7c080",
      bg = "#1F2430",
    },
    datetime = {
      fg = "#7a8478",
      bg = "#1F2430",
    },
    battery = {
      fg = "#7a8478",
      bg = "#1F2430",
    },
  },
  force_show = false,
  manage_tmux_status = true,
}

return M
