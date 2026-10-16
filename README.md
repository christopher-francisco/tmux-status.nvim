# 💎 tmux-status.nvim

<!-- panvimdoc-ignore-start -->

![code size](https://img.shields.io/github/languages/code-size/christopher-francisco/tmux-status.nvim?style=flat-square)
![license](https://img.shields.io/github/license/christopher-francisco/tmux-status.nvim?style=flat-square)

<!-- panvimdoc-ignore-end -->

Keep your setup clean by having only 1 status bar.

https://github.com/user-attachments/assets/65e9026f-ecda-456e-a894-cbac4f919a83

## ✨ Features

* 🛠️ Integrate Tmux status directly into your Neovim statusline (i.e: [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim))
* 👀 Automatically hide/show Tmux status so that there's only ever 1 line
* 📍 Both Neovim and Tmux command line in the same location (tell them apart through color)
* 🌐 Component-based design for flexibility and portability
* 🎨 Customize colors
* 🖼️ Customize Tmux status windows flag with your favorite icons

## ⚡️ Requirements

* Neovim >= 0.9.5
* Tmux >= 3.2
* (Optional) a [Nerd Font](https://www.nerdfonts.com/) for icons in components, such as the Tmux status window flags

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
  {
    "christopher-francisco/tmux-status.nvim",
    lazy = true,
    opts = {},
  },
```

## 🖋️ Usage

Just call the component function: `require('tmux-status').tmux_windows()`

### [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

```lua
local opts = {
  sections = {
    lualine_c = {
      -- ...other lualine components
      {
        require('tmux-status').tmux_windows,
        cond = require('tmux-status').show,
        padding = { left = 3 },
      },
    },
    lualine_z = {
      -- ...other lualine components
      {
        require('tmux-status').tmux_session,
        cond = require('tmux-status').show,
        padding = { left = 3 },
      },
    }
  }
}
```

## 🧩 Components

| Component                                           | Description                                                                                                                               |
| ---                                                 | ---                                                                                                                                       |
| `require('tmux-status').tmux_windows()`             | Returns Tmux windows with their highlight groups (active, recently inactive, inactive) and the icon corresponding to their window flags   |
| `require('tmux-status').tmux_session()`             | Returns Tmux session name with its highlight group                                                                                        |
| `require('tmux-status').tmux_datetime()`            | Returns the datetime (see `man date`) with its highlight group                                                                            |
| `require('tmux-status').tmux_battery()`             | Returns the battery (requires `pmset`, may not be availabe in all OS) with its highlight group                                            |
| `require('tmux-status').tmux_render_format(format)` | Advanced component for those who want extra control. Requires familiarity with Tmux configurations. See [Advance usage](#advance-usage)   |

## ⚙️  Configuration

<details><summary>Default Options</summary>

<!-- config:start -->

```lua
---@type TmuxStatusOptions
local defaults = {
  window = {
    separator = "  ",
    icon_zoom = "",
    icon_mark = "",
    icon_bell = "",
    icon_mute = "",
    icon_activity = "",
    -- "dir" | "name" | "index_name"
    -- if not listed above, text will be passed directly to tmux formatting
    text = "dir",
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
  -- Each color is a foreground ("#e69875") or a table with fg and/or bg. `colors` can also be a
  -- function returning this table: it's called again on every colorscheme change.
  colors = {
    window_active = { fg = "#e69875", bg = "#1F2430" },
    window_inactive = { fg = "#859289", bg = "#1F2430" },
    window_inactive_recent = { fg = "#3f5865", bg = "#1F2430" },
    session = { fg = "#a7c080", bg = "#1F2430" },
    datetime = { fg = "#7a8478", bg = "#1F2430" },
    battery = { fg = "#7a8478", bg = "#1F2430" },
  },
  force_show = false,        -- Force components to be shown regardless of Tmux status
  manage_tmux_status = true, -- Set to false if you do NOT want the plugin to turn Tmux status on/off
}
```

<!-- config:end -->

</details>

## Advance usage

Advanced components for those who want extra control. Must be familiar with Tmux config. Renders a format. See FORMATS in tmux manual.

```lua
local lualine_x = {
  {
    function ()
      local text = '%#my_custom_highlight_title# Catppuccin: %#my_custom_highlight_description#'
      return text .. require('tmux-status').tmux_render_format('@catppuccin_flavour')
    end,
    cond = require('tmux-status').show,
  },
}
```
