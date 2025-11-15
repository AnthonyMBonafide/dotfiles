{ config, pkgs, ... }:

{
  # Wayland-native screensaver and visual effects
  # Shared between Hyprland and Niri for consistent screensaver behavior

  home.packages = with pkgs; [
    # Wayland-native screen lockers with effects
    swaylock-effects   # Enhanced swaylock with blur, effects, and customization

    # Visual effects and screensavers for Wayland
    cava               # Audio visualizer for terminal
    pipes-rs           # Animated pipes screensaver (Rust rewrite)
    cbonsai            # Bonsai tree generator for terminal

    # Shader-based backgrounds (Wayland-native)
    # shaderbg         # Uncomment if you want shader-based animated backgrounds
  ];

  # Swaylock-effects configuration (Wayland-native screen locker with visual effects)
  xdg.configFile."swaylock/config".text = ''
    # Swaylock-effects configuration
    # This is a Wayland-native screen locker with blur, fade, and clock effects

    # Display options
    ignore-empty-password
    show-failed-attempts

    # Visual effects
    screenshots
    clock
    indicator

    # Blur and fade effects
    effect-blur=7x5
    effect-vignette=0.5:0.5
    fade-in=0.2

    # Colors (matching your color scheme)
    color=1e1e2e

    # Ring colors
    ring-color=89b4fa
    key-hl-color=a6e3a1
    line-color=00000000
    inside-color=1e1e2e88
    separator-color=00000000

    # Ring indicator
    bs-hl-color=f38ba8
    caps-lock-bs-hl-color=f38ba8
    caps-lock-key-hl-color=a6e3a1

    # Text colors
    text-color=cdd6f4
    text-clear-color=cdd6f4
    text-caps-lock-color=f9e2af
    text-ver-color=89b4fa
    text-wrong-color=f38ba8

    # Clock and date
    indicator-radius=100
    indicator-thickness=10

    # Font
    font="Noto Sans"
    font-size=24

    # Grace period (seconds before requiring password)
    grace=2
    grace-no-mouse
    grace-no-touch
  '';

  # Configuration for terminal-based visualizers
  # These can be run manually or triggered on idle for visual effects
  xdg.configFile."cava/config".text = ''
    [general]
    framerate = 60
    bars = 0

    [input]
    method = pulse
    source = auto

    [output]
    method = ncurses

    [color]
    gradient = 1
    gradient_color_1 = '#89b4fa'
    gradient_color_2 = '#a6e3a1'
    gradient_color_3 = '#f9e2af'
    gradient_color_4 = '#f38ba8'
  '';
}
