{ config, pkgs, ... }:

let
  # Download scenic wallpaper from wallhaven
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/gj/wallhaven-gjj89q.jpg";
    sha256 = "sha256-BMyPZCT704JDjqsx6nMjfPs30S/Bq3gbpvksQM+BiBc=";
  };
in
{
  # Hyprland window manager and ecosystem
  # This module configures Hyprland with all necessary tools and utilities

  home.packages = with pkgs; [
    # Core Hyprland utilities
    hyprpaper          # Wallpaper daemon
    hypridle           # Idle management
    hyprlock           # Screen locker
    hyprpicker         # Color picker

    # Wallpapers
    nixos-artwork.wallpapers.nineish-dark-gray
    gnome-backgrounds  # Scenic photography wallpapers

    # Status bar and system tray
    waybar             # Highly customizable status bar

    # Application launcher
    wofi               # Wayland-native launcher (rofi alternative)

    # Notifications
    dunst              # Notification daemon (or use mako)
    libnotify          # For notify-send command

    # Screenshots and screen recording
    grim               # Screenshot tool for wayland
    slurp              # Screen area selection
    swappy             # Screenshot editor
    wf-recorder        # Screen recorder for wlroots

    # Clipboard
    wl-clipboard       # Already in nixos-desktop.nix, but good to ensure
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
    blueman               # Bluetooth manager (if needed)

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
    libsForQt5.qt5ct   # Qt5 configuration tool
    adwaita-icon-theme # GTK icon theme

    # Fonts (if not already configured)
    noto-fonts
    noto-fonts-emoji
    font-awesome       # For waybar icons

    # Other useful tools
    wev                # Wayland event viewer (for debugging key codes)
    wlr-randr          # Monitor configuration
  ];

  # Hyprland-specific configurations
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;  # Enable systemd integration

    extraConfig = ''
      # Keyboard and XKB Configuration Notes:
      # - XKB options set to reduce virtual modifier conflicts
      # - Some XWayland keysym warnings (XF86RefreshRateToggle, etc.) are harmless
      # - XDG portal "pidns" warnings are informational and don't affect functionality

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,preferred,auto,1

      # Execute apps at launch
      exec-once = waybar
      exec-once = dunst
      exec-once = hypridle
      exec-once = hyprpaper
      exec-once = nm-applet
      exec-once = blueman-applet
      exec-once = wl-paste --type text --watch cliphist store
      exec-once = wl-paste --type image --watch cliphist store

      # Source color scheme
      source = ~/.config/hypr/colors.conf

      # Input configuration
      input {
          kb_layout = us
          kb_variant =
          kb_model =
          kb_options = ctrl:nocaps,compose:ralt
          kb_rules =

          follow_mouse = 1
          sensitivity = 0

          touchpad {
              natural_scroll = true
              tap-to-click = true
              drag_lock = true
          }
      }

      # XWayland configuration
      xwayland {
          force_zero_scaling = true
      }

      # General window layout
      general {
          gaps_in = 5
          gaps_out = 10
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)
          layout = dwindle
          resize_on_border = true
      }

      # Decorations (rounded corners, blur, shadows)
      decoration {
          rounding = 10

          blur {
              enabled = true
              size = 3
              passes = 1
              new_optimizations = true
          }

          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }
      }

      # Animations
      animations {
          enabled = true
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      # Layouts
      dwindle {
          pseudotile = true
          preserve_split = true
      }

      master {
          new_status = master
      }

      # Gestures
      # Note: workspace_swipe options removed in newer Hyprland versions
      gestures {
      }

      # Misc settings
      misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          mouse_move_enables_dpms = true
          # enable_hyprcursor removed - now always enabled by default
      }

      # Window rules
      windowrulev2 = float, class:^(pavucontrol)$
      windowrulev2 = float, class:^(blueman-manager)$
      windowrulev2 = float, class:^(nm-connection-editor)$
      windowrulev2 = float, class:^(thunar)$

      # Keybindings
      $mainMod = SUPER

      # Applications
      bind = $mainMod, Return, exec, ghostty
      bind = $mainMod, Q, killactive,
      bind = $mainMod SHIFT, Escape, exit,
      bind = $mainMod, Escape, exec, wlogout
      bind = $mainMod, E, exec, thunar
      bind = $mainMod, V, togglefloating,
      bind = $mainMod SHIFT, Space, exec, wofi --show drun
      bind = $mainMod, P, pseudo,
      bind = $mainMod, J, togglesplit,
      bind = $mainMod, F, fullscreen,
      bind = $mainMod, B, exec, firefox
      bind = $mainMod SHIFT, B, exec, firefox --private-window
      bind = $mainMod, M, exec, spotify
      bind = $mainMod, D, exec, discord

      # Screenshot
      bind = , Print, exec, grim -g "$(slurp)" - | swappy -f -
      bind = $mainMod, Print, exec, grim - | swappy -f -

      # Clipboard history
      bind = $mainMod, C, exec, cliphist list | wofi -dmenu | cliphist decode | wl-copy

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Move focus with mainMod + vim keys
      bind = $mainMod, h, movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, k, movefocus, u
      bind = $mainMod, j, movefocus, d

      # Move windows with mainMod + SHIFT + arrow keys
      bind = $mainMod SHIFT, left, movewindow, l
      bind = $mainMod SHIFT, right, movewindow, r
      bind = $mainMod SHIFT, up, movewindow, u
      bind = $mainMod SHIFT, down, movewindow, d

      # Move windows with mainMod + SHIFT + vim keys
      bind = $mainMod SHIFT, h, movewindow, l
      bind = $mainMod SHIFT, l, movewindow, r
      bind = $mainMod SHIFT, k, movewindow, u
      bind = $mainMod SHIFT, j, movewindow, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Media keys
      bind = , XF86AudioRaiseVolume, exec, pamixer -i 5
      bind = , XF86AudioLowerVolume, exec, pamixer -d 5
      bind = , XF86AudioMute, exec, pamixer -t
      bind = , XF86AudioPlay, exec, playerctl play-pause
      bind = , XF86AudioPause, exec, playerctl play-pause
      bind = , XF86AudioNext, exec, playerctl next
      bind = , XF86AudioPrev, exec, playerctl previous

      # Brightness keys
      bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
      bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

      # Lock screen
      bind = $mainMod SHIFT, L, exec, hyprlock
    '';
  };

  # GTK theme configuration for consistency
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt theme configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # XDG configuration for Wayland
  xdg.configFile = {
    # Simple color scheme
    "hypr/colors.conf".text = ''
      $background = rgb(1e1e2e)
      $foreground = rgb(cdd6f4)
      $color0 = rgb(45475a)
      $color1 = rgb(f38ba8)
      $color2 = rgb(a6e3a1)
      $color3 = rgb(f9e2af)
      $color4 = rgb(89b4fa)
      $color5 = rgb(f5c2e7)
      $color6 = rgb(94e2d5)
      $color7 = rgb(bac2de)
    '';

    # Waybar configuration
    "waybar/config".text = ''
      {
        "layer": "top",
        "position": "top",
        "height": 30,
        "spacing": 4,

        "modules-left": ["hyprland/workspaces", "hyprland/window"],
        "modules-center": ["clock"],
        "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery", "tray"],

        "hyprland/workspaces": {
          "disable-scroll": false,
          "all-outputs": true,
          "format": "{icon}",
          "format-icons": {
            "1": "1",
            "2": "2",
            "3": "3",
            "4": "4",
            "5": "5",
            "6": "6",
            "7": "7",
            "8": "8",
            "9": "9",
            "10": "10"
          }
        },

        "hyprland/window": {
          "format": "{}",
          "max-length": 50
        },

        "tray": {
          "spacing": 10
        },

        "clock": {
          "timezone": "America/New_York",
          "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
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

    # Waybar styling
    "waybar/style.css".text = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "Noto Sans", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #cdd6f4;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.2);
      }

      #workspaces button.active {
        background-color: rgba(137, 180, 250, 0.4);
      }

      #workspaces button.urgent {
        background-color: #f38ba8;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray,
      #window {
        padding: 0 10px;
        margin: 0 2px;
        background-color: rgba(69, 71, 90, 0.6);
        border-radius: 5px;
      }

      #window {
        color: #cdd6f4;
      }

      #battery.charging {
        color: #a6e3a1;
      }

      #battery.warning:not(.charging) {
        color: #f9e2af;
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      @keyframes blink {
        to {
          background-color: #f38ba8;
          color: #1e1e2e;
        }
      }

      #pulseaudio.muted {
        color: #f38ba8;
      }

      #network.disconnected {
        color: #f38ba8;
      }
    '';

    # Wofi (application launcher) configuration
    "wofi/config".text = ''
      width=600
      height=400
      location=center
      show=drun
      prompt=Search...
      filter_rate=100
      allow_markup=true
      no_actions=true
      halign=fill
      orientation=vertical
      content_halign=fill
      insensitive=true
      allow_images=true
      image_size=40
      gtk_dark=true
    '';

    # Wofi styling
    "wofi/style.css".text = ''
      * {
        font-family: "Noto Sans";
        font-size: 14px;
      }

      window {
        margin: 0px;
        border: 2px solid #89b4fa;
        border-radius: 10px;
        background-color: #1e1e2e;
      }

      #input {
        margin: 10px;
        padding: 8px;
        border: none;
        border-radius: 5px;
        color: #cdd6f4;
        background-color: #313244;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: #1e1e2e;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: #1e1e2e;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }

      #entry:selected {
        background-color: #89b4fa;
        border-radius: 5px;
      }

      #entry:selected #text {
        color: #1e1e2e;
        font-weight: bold;
      }
    '';

    # Hyprlock (screen locker) configuration
    "hypr/hyprlock.conf".text = ''
      general {
        disable_loading_bar = false
        hide_cursor = true
        grace = 0
        no_fade_in = false
      }

      background {
        monitor =
        path = screenshot
        blur_passes = 3
        blur_size = 8
        noise = 0.0117
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
      }

      input-field {
        monitor =
        size = 250, 50
        outline_thickness = 3
        dots_size = 0.33
        dots_spacing = 0.15
        dots_center = true
        outer_color = rgb(89b4fa)
        inner_color = rgb(1e1e2e)
        font_color = rgb(cdd6f4)
        fade_on_empty = true
        placeholder_text = <i>Password...</i>
        hide_input = false
        position = 0, -20
        halign = center
        valign = center
      }

      label {
        monitor =
        text = Hi $USER
        color = rgba(cdd6f4, 1.0)
        font_size = 25
        font_family = Noto Sans
        position = 0, 80
        halign = center
        valign = center
      }

      label {
        monitor =
        text = $TIME
        color = rgba(cdd6f4, 1.0)
        font_size = 60
        font_family = Noto Sans
        position = 0, 150
        halign = center
        valign = center
      }
    '';

    # Hypridle (idle management) configuration
    "hypr/hypridle.conf".text = ''
      general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
      }

      listener {
        timeout = 300  # 5 minutes
        on-timeout = brightnessctl -s set 10
        on-resume = brightnessctl -r
      }

      listener {
        timeout = 600  # 10 minutes
        on-timeout = loginctl lock-session
      }

      listener {
        timeout = 900  # 15 minutes
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
      }

      listener {
        timeout = 1800  # 30 minutes
        on-timeout = systemctl suspend
      }
    '';

    # Hyprpaper (wallpaper) configuration
    "hypr/hyprpaper.conf".text = ''
      # Preload wallpapers
      preload = ${wallpaper}

      # Set wallpaper for all monitors
      wallpaper = ,${wallpaper}

      # Enable splash text rendering
      splash = false

      # Disable IPC to improve performance
      ipc = off
    '';
  };

  # Configure dunst notification daemon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#89b4fa";
        font = "Noto Sans 10";
      };
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
    };
  };

  # Blueman configuration
  xdg.configFile."blueman/blueman-applet.conf".text = ''
    [General]
    plugin-list=!GameControllerWakelock
  '';

  # Environment variables for Wayland
  home.sessionVariables = {
    # Wayland environment variables
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
    MOZ_ENABLE_WAYLAND = "1";  # Enable Wayland for Firefox
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # XKB configuration to reduce warnings
    XKB_DEFAULT_LAYOUT = "us";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps,compose:ralt";
  };
}
