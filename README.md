# 💎 tmux-status.nvim

<!-- panvimdoc-ignore-start -->

![code size](https://img.shields.io/github/languages/code-size/christopher-francisco/tmux-status.nvim?style=flat-square)
![license](https://img.shields.io/github/license/christopher-francisco/tmux-status.nvim?style=flat-square)

<!-- panvimdoc-ignore-end -->

Keep your setup clean by having only 1 status bar.

![image](https://github.com/user-attachments/assets/a2c08bea-fed9-4446-b5b3-9b382223ef24)

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

| Component                               | Description                                                                                                                               |
| ---                                     | ---                                                                                                                                       |
| `require('tmux-status').tmux_windows()` | Returns Tmux windows with their highlight groups (active, recently inactive, inactive) and the icon corresponding to their window flags   |
| `require('tmux-status').tmux_session()` | Returns Tmux session name with its highlight group                                                                                        |

## ⚙️  Configuration

<details><summary>Default Options</summary>

<!-- config:start -->

```lua
---@type TmuxStatusOptions
local defaults = {
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
  force_show = false,        -- Force components to be shown regardless of Tmux status
  manage_tmux_status = true, -- Set to false if you do NOT want the plugin to turn Tmux status on/off
}
```

<!-- config:end -->

</details>
