{ config, pkgs, ... }:

{
  # Host-specific configuration for Arch Linux Desktop
  # This is an example configuration for Arch/Manjaro/Endeavor OS

  # System information
  home.username = "anthony";  # Usually lowercase on Linux
  home.homeDirectory = "/home/anthony";

  # System architecture is defined in flake.nix
  # This host uses: x86_64-linux

  # Allow unfree packages for standalone home-manager
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "claude-code"
  ];

  # Linux-specific packages
  home.packages = with pkgs; [
    # Display/GUI tools
    xclip           # X11 clipboard utility
    wl-clipboard    # Wayland clipboard utility (if using Wayland)

    # Linux-specific utilities
    # Add more as needed
  ];

  # Linux-specific configurations
  # You might want to add:
  # - Display manager configs
  # - Window manager configs (i3, sway, hyprland, etc.)
  # - X11/Wayland specific settings
}
