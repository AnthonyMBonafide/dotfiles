{ config, pkgs, ... }:

{
  # Host-specific home-manager configuration for NixOS Laptop

  # Import window manager modules for this system
  # Both Hyprland and Niri are available - you can choose at login
  imports = [
    ../modules/hyprland.nix
    ../modules/niri.nix
    ../modules/screensaver.nix
  ];

  # User information (required for home-manager)
  home.username = "anthony";
  home.homeDirectory = "/home/anthony";

  # NixOS-specific packages
  home.packages = with pkgs; [
    # Display/GUI tools
    xclip           # X11 clipboard utility (for X11 apps)
    # wl-clipboard is now provided by hyprland module

    # Additional NixOS-specific utilities
    # Add more as needed
  ];

  # NixOS-specific configurations
  # Add any additional NixOS-specific home-manager settings here
}
