# Niri Keybindings Reference

Quick reference guide for all Niri window manager keybindings.

**Modifier Key**: `Mod` = Super/Windows Key

---

## 🚀 APPLICATION LAUNCHERS

| Keybinding | Action |
|------------|--------|
| `Mod+Return` | Open terminal (ghostty) |
| `Mod+Shift+Space` | Application launcher (wofi) |
| `Mod+E` | File manager (Thunar) |
| `Mod+B` | Browser (Firefox) |
| `Mod+Shift+B` | Private browser window |
| `Mod+M` | Spotify |
| `Mod+D` | Discord |

---

## 🪟 WINDOW MANAGEMENT

| Keybinding | Action |
|------------|--------|
| `Mod+Q` | Close window |
| `Mod+V` | Toggle floating |
| `Mod+F` | Fullscreen window |
| `Mod+Shift+F` | Toggle windowed fullscreen |
| `Mod+W` | Toggle window tabbed display |

---

## ⚙️ SYSTEM CONTROLS

| Keybinding | Action |
|------------|--------|
| `Mod+O` | Toggle Overview mode |
| `Mod+Escape` | Logout menu (wlogout) |
| `Mod+Shift+Escape` | Quit Niri |
| `Mod+Shift+Backspace` | Lock screen |
| `Mod+Shift+/` | Show hotkey overlay |

---

## 📸 SCREENSHOTS

| Keybinding | Action |
|------------|--------|
| `Print` | Interactive area selection |
| `Mod+Print` | Full screen screenshot |
| `Alt+Print` | Screenshot focused window |
| `Ctrl+Print` | Screenshot entire screen |

---

## 📋 CLIPBOARD

| Keybinding | Action |
|------------|--------|
| `Mod+C` | Clipboard history menu |

---

## 🧭 FOCUS NAVIGATION

| Keybinding | Action |
|------------|--------|
| `Mod+H` / `Mod+Left` | Focus column left |
| `Mod+L` / `Mod+Right` | Focus column right |
| `Mod+K` / `Mod+Up` | Focus window up |
| `Mod+J` / `Mod+Down` | Focus window down |
| `Mod+Home` | Focus first column |
| `Mod+End` | Focus last column |

---

## 🔄 WINDOW/COLUMN MOVEMENT

| Keybinding | Action |
|------------|--------|
| `Mod+Shift+H` / `Mod+Shift+Left` | Move column left |
| `Mod+Shift+L` / `Mod+Shift+Right` | Move column right |
| `Mod+Shift+K` / `Mod+Shift+Up` | Move window up |
| `Mod+Shift+J` / `Mod+Shift+Down` | Move window down |
| `Mod+Ctrl+Home` | Move column to first position |
| `Mod+Ctrl+End` | Move column to last position |

---

## 🖥️ MONITOR MANAGEMENT (Multi-Monitor)

| Keybinding | Action |
|------------|--------|
| `Mod+Ctrl+H` | Focus monitor left |
| `Mod+Ctrl+J` | Focus monitor down |
| `Mod+Ctrl+K` | Focus monitor up |
| `Mod+Ctrl+L` | Focus monitor right |
| `Mod+Ctrl+Shift+H` | Move window to monitor left |
| `Mod+Ctrl+Shift+J` | Move window to monitor down |
| `Mod+Ctrl+Shift+K` | Move window to monitor up |
| `Mod+Ctrl+Shift+L` | Move window to monitor right |

---

## 🗂️ WORKSPACE MANAGEMENT

### Switch Workspaces
| Keybinding | Action |
|------------|--------|
| `Mod+1` to `Mod+0` | Focus workspace 1-10 |
| `Mod+Page_Down` / `Mod+WheelScrollDown` | Focus workspace down |
| `Mod+Page_Up` / `Mod+WheelScrollUp` | Focus workspace up |
| `Mod+U` | Focus workspace down (alternative) |
| `Mod+I` | Focus workspace up (alternative) |

### Move Windows to Workspaces
| Keybinding | Action |
|------------|--------|
| `Mod+Shift+1` to `Mod+Shift+0` | Move to workspace 1-10 |
| `Mod+Ctrl+U` | Move to workspace down |
| `Mod+Ctrl+I` | Move to workspace up |

### Move Workspaces
| Keybinding | Action |
|------------|--------|
| `Mod+Shift+Page_Up` | Move workspace up |
| `Mod+Shift+Page_Down` | Move workspace down |

---

## 📏 COLUMN/WINDOW SIZING

### Fine Control
| Keybinding | Action |
|------------|--------|
| `Mod+Equal` | Increase column width +10% |
| `Mod+Minus` | Decrease column width -10% |
| `Mod+Shift+Equal` | Increase window height +10% |
| `Mod+Shift+Minus` | Decrease window height -10% |

### Quick Presets
| Keybinding | Action |
|------------|--------|
| `Mod+Comma` | Set column width to 33% |
| `Mod+Period` | Set column width to 50% |
| `Mod+Slash` | Set column width to 67% |
| `Mod+R` | Cycle through preset widths |
| `Mod+Shift+R` | Cycle through preset heights |

### Advanced Operations
| Keybinding | Action |
|------------|--------|
| `Mod+Ctrl+F` | Expand column to 100% width |
| `Mod+Ctrl+C` / `Mod+Shift+C` | Center column |

---

## 🔧 NIRI-SPECIFIC FEATURES

| Keybinding | Action |
|------------|--------|
| `Mod+BracketLeft` | Consume window into column |
| `Mod+BracketRight` | Expel window from column |

---

## 🎵 MEDIA CONTROLS

| Keybinding | Action |
|------------|--------|
| `XF86AudioRaiseVolume` | Volume up +5% |
| `XF86AudioLowerVolume` | Volume down -5% |
| `XF86AudioMute` | Mute/unmute |
| `XF86AudioPlay` / `XF86AudioPause` | Play/pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |

---

## 🔆 BRIGHTNESS CONTROLS

| Keybinding | Action |
|------------|--------|
| `XF86MonBrightnessUp` | Brightness up +5% |
| `XF86MonBrightnessDown` | Brightness down -5% |

---

## 💡 TIPS

- **Overview Mode** (`Mod+O`): Get a bird's eye view of all workspaces
- **Tabbed Windows** (`Mod+W`): Stack windows as tabs in a column
- **Column System**: Niri uses a unique scrollable tiling layout with columns
- **Vim Keys**: Most navigation uses H/J/K/L for consistency
- **Idle Lock**: Screen locks automatically after 5 minutes, monitors power off after 10 minutes

---

## 📚 COMMON WORKFLOWS

### Open and Arrange Apps
1. `Mod+Return` - Open terminal
2. `Mod+B` - Open browser
3. `Mod+R` - Cycle column width to preferred size
4. `Mod+Shift+L` - Move column right

### Multi-Monitor Setup
1. `Mod+Ctrl+L` - Focus right monitor
2. `Mod+Ctrl+Shift+H` - Move window to left monitor

### Quick Screenshot
1. `Print` - Start area selection
2. Draw selection area
3. Edit in Swappy

---

*Configuration location: `/home/anthony/dotfiles/modules/niri.nix`*
