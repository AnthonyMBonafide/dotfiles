{ config, pkgs, ... }:

{
  # Host-specific home-manager configuration for lambda-core

  # Import common desktop configuration
  imports = [
    ../../modules/home/desktop/common.nix
  ];

  # Host-specific configurations
  # Add any lambda-core-specific home-manager settings here
}
