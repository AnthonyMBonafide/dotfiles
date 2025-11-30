{ config, pkgs, ... }:

{
  # Shared desktop configuration for NixOS systems
  # Includes window manager, screensaver, and common desktop settings

  imports = [
    ../niri
    ../screensaver.nix
  ];

  # Enable Niri window manager
  myHome.niri.enable = true;

  # User information (required for home-manager)
  home.username = "anthony";
  home.homeDirectory = "/home/anthony";

  # Stylix home-manager specific settings
  stylix.targets = {
    # Firefox profile configuration
    firefox.profileNames = [ "default" ];

    # Qt theming configuration
    qt = {
      enable = true;
      platform = "qtct";
    };
  };

  # Desktop-specific packages
  home.packages = with pkgs; [
    # Display/GUI tools
    xclip           # X11 clipboard utility (for X11 apps)
    # wl-clipboard is now provided by niri module

    # Additional desktop utilities
    # Add more as needed
  ];

  # Desktop-specific configurations
  # Add any additional desktop home-manager settings here
}
