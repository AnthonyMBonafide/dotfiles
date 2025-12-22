{ config, pkgs, ... }:

{
  # Host-specific home-manager configuration for homelab servers
  # This is a minimal configuration for headless server use

  # Essential packages for server management
  home.packages = with pkgs; [
    htop
    tmux
    vim
    git
  ];

  # Host-specific configurations
  # Add any homelab-specific home-manager settings here
}
