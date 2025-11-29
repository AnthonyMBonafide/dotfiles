{ config, pkgs, ... }:

{
  # Host-specific home-manager configuration for black-mesa

  # Import common desktop configuration
  imports = [
    ../../modules/home/desktop/common.nix
  ];

  # Host-specific configurations
  # Add any black-mesa-specific home-manager settings here
}
