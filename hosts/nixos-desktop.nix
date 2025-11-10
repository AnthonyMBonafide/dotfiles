{ config, pkgs, ... }:

{
  # Host-specific home-manager configuration for NixOS Desktop

  # User information (required for home-manager)
  home.username = "anthony";
  home.homeDirectory = "/home/anthony";

  # NixOS-specific packages
  home.packages = with pkgs; [
    # Display/GUI tools
    xclip           # X11 clipboard utility
    wl-clipboard    # Wayland clipboard utility

    # NixOS-specific utilities
    # Add more as needed
  ];

  # NixOS-specific configurations
  # Add any additional NixOS-specific home-manager settings here
}
