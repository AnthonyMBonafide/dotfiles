{ config, pkgs, ... }:

let
  # Download scenic wallpaper from wallhaven
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/gj/wallhaven-gjj89q.jpg";
    sha256 = "sha256-BMyPZCT704JDjqsx6nMjfPs30S/Bq3gbpvksQM+BiBc=";
  };
in
{
  # Niri window manager and ecosystem
  # Niri is a scrollable-tiling Wayland compositor with unique horizontal workspace scrolling

  # Import Niri configuration modules
  imports = [
    (import ./config.nix { inherit config pkgs wallpaper; })
    ./waybar.nix
  ];

  # Packages for Niri window manager ecosystem
  home.packages = with pkgs; [
    # Core utilities
    waybar             # Status bar (works with Niri)
    wofi               # Application launcher
    dunst              # Notification daemon
    libnotify          # For notify-send command
    # xwayland-satellite is provided by the gaming module (modules/system/hardware/gaming.nix)

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

  # Screensaver/lock configuration is in modules/screensaver.nix
}
