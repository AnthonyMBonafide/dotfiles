# Homelab server configuration for Beelink mini computers
# This configuration is designed for headless server use

{ config, pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix

    # Core system modules
    ../../modules/system/core/common.nix
    ../../modules/system/core/nix-settings.nix
    ../../modules/system/core/users.nix
    ../../modules/system/core/auto-update.nix

    # Server services
    ../../modules/system/services/forgejo.nix
    ../../modules/system/services/jellyfin.nix
    ../../modules/system/services/vaultwarden.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname (you can override this per machine)
  networking.hostName = "homelab-01";

  # Enable SSH for remote management
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Firewall configuration
  # Open ports for services
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22    # SSH
      80    # HTTP
      443   # HTTPS
      3000  # Forgejo
      8096  # Jellyfin
      8080  # Vaultwarden
    ];
  };

  # Enable homelab services
  homelab.services.forgejo.enable = true;
  homelab.services.jellyfin.enable = true;
  homelab.services.vaultwarden.enable = true;

  # Disable desktop-related services for headless operation
  services.xserver.enable = lib.mkForce false;
  services.printing.enable = lib.mkForce false;
  hardware.bluetooth.enable = lib.mkForce false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "25.05";
}
