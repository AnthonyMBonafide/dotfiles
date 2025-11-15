{ config, pkgs, ... }:

let
  # Download scenic wallpaper from wallhaven (same as Hyprland)
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/gj/wallhaven-gjj89q.jpg";
    sha256 = "sha256-BMyPZCT704JDjqsx6nMjfPs30S/Bq3gbpvksQM+BiBc=";
  };
in
{
  # Niri window manager and ecosystem
  # Niri is a scrollable-tiling Wayland compositor with unique horizontal workspace scrolling

  home.packages = with pkgs; [
    # Core utilities (shared with Hyprland)
    waybar             # Status bar (works with Niri)
    wofi               # Application launcher
    dunst              # Notification daemon
    libnotify          # For notify-send command

    # Screenshots and screen recording
    grim               # Screenshot tool for wayland
    slurp              # Screen area selection
    swappy             # Screenshot editor
    wf-recorder        # Screen recorder

    # Clipboard
    wl-clipboard       # Clipboard utilities
    cliphist           # Clipboard history

    # Logout/power menu
    wlogout            # Wayland logout menu

    # System utilities
    brightnessctl      # Brightness control
    playerctl          # Media player control
    pamixer            # PulseAudio mixer
    pavucontrol        # PulseAudio volume control GUI

    # Network and Bluetooth
    networkmanagerapplet  # Network manager tray icon
    blueman               # Bluetooth manager

    # File management
    xfce.thunar           # Lightweight file manager
    xfce.thunar-volman    # Removable device management
    xfce.thunar-archive-plugin

    # Image viewer
    imv                # Wayland image viewer

    # PDF viewer
    zathura            # Lightweight PDF viewer

    # Theming and appearance
    qt5.qtwayland      # Qt5 Wayland support
    qt6.qtwayland      # Qt6 Wayland support
    adwaita-icon-theme # GTK icon theme

    # Fonts
    noto-fonts
    noto-fonts-color-emoji
    font-awesome       # For waybar icons

    # Wallpaper setter for Niri
    swaybg             # Wallpaper tool (works with any wlroots-based compositor)

    # Idle management
    swayidle           # Idle daemon for auto-locking

    # Monitor management
    wlopm              # Wayland output power management
  ];

  # Niri configuration
  # Niri uses KDL (KubeDoc Language) for configuration
  xdg.configFile."niri/config.kdl".text = ''
    // Niri configuration
    // This configuration mirrors Hyprland keybindings where possible

    // Input configuration
    input {
        keyboard {
            xkb {
                layout "us"
                options "ctrl:nocaps,compose:ralt"
            }
            repeat-delay 600
            repeat-rate 25
        }

        touchpad {
            tap
            natural-scroll
            dwt
            dwtp
            accel-speed 0.0
        }

        mouse {
            natural-scroll
            accel-speed 0.0
        }

        // Disable mouse cursor hiding on keyboard input (for compatibility)
        disable-power-key-handling
    }

    // Output configuration (monitors)
    // Left monitor: Dell P2419H (1920x1080)
    output "DP-3" {
        mode "1920x1080@60.000"
        scale 1.0
        transform "normal"
        position x=0 y=0
    }

    // Right monitor: Dell AW2521HF (1920x1080)
    output "DP-2" {
        mode "1920x1080@60.000"
        scale 1.0
        transform "normal"
        position x=1920 y=0
    }

    // Right monitor (third monitor - will activate when detected)
    // Uncomment and configure when third monitor is detected
    // Check which port with: cat /sys/class/drm/card0-*/status
    // output "DP-1" {
    //     mode "1920x1080@60.000"
    //     scale 1.0
    //     transform "normal"
    //     position x=3840 y=0
    // }

    // Alternatively for DP-4:
    // output "DP-4" {
    //     mode "1920x1080@60.000"
    //     scale 1.0
    //     transform "normal"
    //     position x=3840 y=0
    // }

    // Or for HDMI:
    // output "HDMI-A-1" {
    //     mode "1920x1080@60.000"
    //     scale 1.0
    //     transform "normal"
    //     position x=3840 y=0
    // }

    // Layout configuration
    // Niri's unique scrollable tiling layout
    layout {
        gaps 10
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color "#33ccff"
            inactive-color "#595959"
        }

        border {
            width 2
            active-color "#33ccff"
            inactive-color "#595959"
        }
    }

    // Window rules
    window-rule {
        match app-id="pavucontrol"
        default-column-width { proportion 0.33333; }
    }

    window-rule {
        match app-id="blueman-manager"
        default-column-width { proportion 0.33333; }
    }

    window-rule {
        match app-id="thunar"
        default-column-width { proportion 0.5; }
    }

    // Animations
    animations {
        slowdown 1.0

        window-open {
            duration-ms 150
            curve "ease-out-expo"
        }

        window-close {
            duration-ms 150
            curve "ease-out-expo"
        }

        window-movement {
            duration-ms 200
            curve "ease-out-cubic"
        }

        workspace-switch {
            duration-ms 200
            curve "ease-out-cubic"
        }

        horizontal-view-movement {
            duration-ms 200
            curve "ease-out-cubic"
        }

        window-resize {
            duration-ms 150
            curve "ease-out-expo"
        }
    }

    // Screenshots
    screenshot-path "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"

    // Prefer no window decorations (server-side decorations)
    prefer-no-csd

    // Spawn programs at startup
    spawn-at-startup "${pkgs.waybar}/bin/waybar"
    spawn-at-startup "${pkgs.dunst}/bin/dunst"
    spawn-at-startup "${pkgs.networkmanagerapplet}/bin/nm-applet"
    spawn-at-startup "${pkgs.blueman}/bin/blueman-applet"
    spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${wallpaper}"
    spawn-at-startup "${pkgs.wl-clipboard}/bin/wl-paste" "--type" "text" "--watch" "${pkgs.cliphist}/bin/cliphist" "store"
    spawn-at-startup "${pkgs.wl-clipboard}/bin/wl-paste" "--type" "image" "--watch" "${pkgs.cliphist}/bin/cliphist" "store"
    spawn-at-startup "${pkgs.swayidle}/bin/swayidle" "-w" "timeout" "300" "${pkgs.hyprlock}/bin/hyprlock" "timeout" "600" "${pkgs.niri}/bin/niri msg action power-off-monitors"

    // Keybindings
    // Modifier key: Super (Windows key)
    binds {
        // ============================================================
        // APPLICATION LAUNCHERS
        // ============================================================
        Mod+Return { spawn "ghostty"; }
        Mod+Shift+Space { spawn "${pkgs.wofi}/bin/wofi" "--show" "drun"; }
        Mod+E { spawn "${pkgs.xfce.thunar}/bin/thunar"; }
        Mod+B { spawn "${pkgs.firefox}/bin/firefox"; }
        Mod+Shift+B { spawn "${pkgs.firefox}/bin/firefox" "--private-window"; }
        Mod+M { spawn "${pkgs.spotify}/bin/spotify"; }
        Mod+D { spawn "${pkgs.discord}/bin/discord"; }

        // ============================================================
        // WINDOW MANAGEMENT
        // ============================================================
        Mod+Q { close-window; }
        Mod+V { toggle-window-floating; }
        Mod+F { set-column-width "100%"; }
        Mod+Shift+F { fullscreen-window; }

        // ============================================================
        // SYSTEM CONTROLS
        // ============================================================
        Mod+Shift+Escape { quit; }
        Mod+Escape { spawn "${pkgs.wlogout}/bin/wlogout"; }
        Mod+Shift+Backspace { spawn "${pkgs.hyprlock}/bin/hyprlock"; }
        Mod+O { toggle-overview; }

        // ============================================================
        // SCREENSHOTS
        // ============================================================
        Print { spawn "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"; }
        Mod+Print { spawn "sh" "-c" "${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f -"; }
        Alt+Print { screenshot-window; }
        Ctrl+Print { screenshot-screen; }

        // ============================================================
        // CLIPBOARD MANAGEMENT
        // ============================================================
        Mod+C { spawn "sh" "-c" "${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"; }

        // ============================================================
        // FOCUS NAVIGATION
        // ============================================================
        // Focus movement with arrow keys
        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up { focus-window-up; }
        Mod+Down { focus-window-down; }

        // Focus movement with vim keys
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-up; }
        Mod+J { focus-window-down; }

        // Focus first/last column
        Mod+Home { focus-column-first; }
        Mod+End { focus-column-last; }

        // ============================================================
        // WINDOW/COLUMN MOVEMENT
        // ============================================================
        // Move windows with arrow keys
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up { move-window-up; }
        Mod+Shift+Down { move-window-down; }

        // Move windows with vim keys
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+J { move-window-down; }

        // Move column to first/last position
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End { move-column-to-last; }

        // ============================================================
        // MONITOR MANAGEMENT (Multi-Monitor)
        // ============================================================
        // Focus different monitors (vim keys)
        Mod+Ctrl+H { focus-monitor-left; }
        Mod+Ctrl+J { focus-monitor-down; }
        Mod+Ctrl+K { focus-monitor-up; }
        Mod+Ctrl+L { focus-monitor-right; }

        // Focus different monitors (arrow keys)
        Mod+Ctrl+Left { focus-monitor-left; }
        Mod+Ctrl+Down { focus-monitor-down; }
        Mod+Ctrl+Up { focus-monitor-up; }
        Mod+Ctrl+Right { focus-monitor-right; }

        // Move windows to different monitors (vim keys)
        Mod+Ctrl+Shift+H { move-column-to-monitor-left; }
        Mod+Ctrl+Shift+J { move-column-to-monitor-down; }
        Mod+Ctrl+Shift+K { move-column-to-monitor-up; }
        Mod+Ctrl+Shift+L { move-column-to-monitor-right; }

        // Move windows to different monitors (arrow keys)
        Mod+Ctrl+Shift+Left { move-column-to-monitor-left; }
        Mod+Ctrl+Shift+Down { move-column-to-monitor-down; }
        Mod+Ctrl+Shift+Up { move-column-to-monitor-up; }
        Mod+Ctrl+Shift+Right { move-column-to-monitor-right; }

        // Power management for monitors
        Mod+Shift+P { spawn "${pkgs.niri}/bin/niri" "msg" "action" "power-off-monitors"; }
        Mod+Ctrl+P { spawn "${pkgs.wlopm}/bin/wlopm" "--toggle" "*"; }

        // ============================================================
        // WORKSPACE MANAGEMENT
        // ============================================================
        // Workspace switching with numbers (1-10)
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+0 { focus-workspace 10; }

        // Move windows to workspaces
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+Shift+0 { move-column-to-workspace 10; }

        // Workspace scrolling (Niri's unique feature)
        Mod+WheelScrollDown { focus-workspace-down; }
        Mod+WheelScrollUp { focus-workspace-up; }
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up { focus-workspace-up; }

        // Alternative workspace navigation
        Mod+U { focus-workspace-down; }
        Mod+I { focus-workspace-up; }

        // Move column to workspace up/down
        Mod+Ctrl+U { move-column-to-workspace-down; }
        Mod+Ctrl+I { move-column-to-workspace-up; }

        // Move workspace up/down
        Mod+Shift+Page_Up { move-workspace-up; }
        Mod+Shift+Page_Down { move-workspace-down; }

        // ============================================================
        // COLUMN/WINDOW SIZING
        // ============================================================
        // Column width adjustments (fine control)
        Mod+Equal { set-column-width "+10%"; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }

        // Column width presets (quick sizing)
        Mod+Comma { set-column-width "33%"; }
        Mod+Period { set-column-width "50%"; }
        Mod+Slash { set-column-width "67%"; }

        // Switch between preset column widths
        Mod+R { switch-preset-column-width; }

        // Switch between preset window heights
        Mod+Shift+R { switch-preset-window-height; }

        // Advanced column operations
        Mod+Ctrl+F { toggle-windowed-fullscreen; }
        Mod+Ctrl+C { center-column; }
        Mod+Shift+C { center-column; }

        // ============================================================
        // NIRI-SPECIFIC FEATURES
        // ============================================================
        // Consume or expel windows from columns
        Mod+BracketLeft { consume-window-into-column; }
        Mod+BracketRight { expel-window-from-column; }

        // Show hotkey overlay
        Mod+Shift+Slash { show-hotkey-overlay; }

        // ============================================================
        // MEDIA CONTROLS
        // ============================================================
        XF86AudioRaiseVolume { spawn "${pkgs.pamixer}/bin/pamixer" "-i" "5"; }
        XF86AudioLowerVolume { spawn "${pkgs.pamixer}/bin/pamixer" "-d" "5"; }
        XF86AudioMute { spawn "${pkgs.pamixer}/bin/pamixer" "-t"; }
        XF86AudioPlay { spawn "${pkgs.playerctl}/bin/playerctl" "play-pause"; }
        XF86AudioPause { spawn "${pkgs.playerctl}/bin/playerctl" "play-pause"; }
        XF86AudioNext { spawn "${pkgs.playerctl}/bin/playerctl" "next"; }
        XF86AudioPrev { spawn "${pkgs.playerctl}/bin/playerctl" "previous"; }

        // ============================================================
        // BRIGHTNESS CONTROLS
        // ============================================================
        XF86MonBrightnessUp { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%-"; }
    }

    // Debug options (disable for production use)
    // debug {
    //     // No debug options currently enabled
    // }
  '';

  # Waybar configuration for Niri
  # Niri-specific waybar module
  xdg.configFile."waybar/config-niri".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 30,
      "spacing": 4,

      "modules-left": ["custom/niri-workspaces", "custom/niri-window"],
      "modules-center": ["clock"],
      "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery", "tray"],

      "custom/niri-workspaces": {
        "format": "{}",
        "exec": "${pkgs.niri}/bin/niri msg --json workspaces | ${pkgs.jq}/bin/jq -r '.[] | .id' | awk '{printf \" %s \", $1}'",
        "interval": 1,
        "on-click": "${pkgs.niri}/bin/niri msg action focus-workspace"
      },

      "custom/niri-window": {
        "format": "{}",
        "exec": "${pkgs.niri}/bin/niri msg --json windows | ${pkgs.jq}/bin/jq -r '.[] | select(.is_focused == true) | .title // \"\"' | head -c 50",
        "interval": 1
      },

      "tray": {
        "spacing": 10
      },

      "clock": {
        "timezone": "America/New_York",
        "tooltip-format": "<big>{:%Y %B}</big>\\n<tt><small>{calendar}</small></tt>",
        "format": "{:%a, %b %d  %I:%M %p}"
      },

      "cpu": {
        "format": " {usage}%",
        "tooltip": false
      },

      "memory": {
        "format": " {}%"
      },

      "battery": {
        "states": {
          "warning": 30,
          "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": " {capacity}%",
        "format-plugged": " {capacity}%",
        "format-alt": "{icon} {time}",
        "format-icons": ["", "", "", "", ""]
      },

      "network": {
        "format-wifi": " {essid} ({signalStrength}%)",
        "format-ethernet": " {ifname}",
        "format-linked": " {ifname} (No IP)",
        "format-disconnected": "⚠ Disconnected",
        "tooltip-format": "{ifname}: {ipaddr}/{cidr}"
      },

      "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-bluetooth": "{icon} {volume}%",
        "format-bluetooth-muted": " {icon}",
        "format-muted": "",
        "format-icons": {
          "headphone": "",
          "hands-free": "",
          "headset": "",
          "phone": "",
          "portable": "",
          "car": "",
          "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
      }
    }
  '';

  # Startup script to launch waybar with Niri config
  xdg.configFile."niri/waybar-launch.sh" = {
    text = ''
      #!/bin/sh
      # Kill existing waybar
      pkill waybar
      # Launch waybar with Niri config
      ${pkgs.waybar}/bin/waybar -c ~/.config/waybar/config-niri -s ~/.config/waybar/style.css &
    '';
    executable = true;
  };

  # GTK, Qt, and environment variables are handled by hyprland.nix
  # No need to duplicate them here since both modules are imported together
}
