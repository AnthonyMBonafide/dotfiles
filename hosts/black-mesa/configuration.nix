# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix

    # Core system modules
    ../../modules/system/core/common.nix
    ../../modules/system/core/nix-settings.nix
    ../../modules/system/core/users.nix
    ../../modules/system/core/auto-update.nix

    # Desktop modules
    ../../modules/system/desktop/desktop-base.nix
    ../../modules/system/desktop/audio.nix

    # Hardware modules
    ../../modules/system/hardware/gaming.nix
    ../../modules/system/hardware/yubikey.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "black-mesa";

  # Enable YubiKey authentication and encryption
  yubikey.auth.enable = true;
  yubikey.encryption.enable = true;

  # NVIDIA GPU Configuration
  # Enable proprietary NVIDIA drivers for better multi-monitor support
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;

  hardware.nvidia = {
    # Use the production branch driver (recommended for most users)
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Modesetting is required for Wayland compositors
    modesetting.enable = true;

    # Enable the NVIDIA settings menu
    nvidiaSettings = true;

    # Power management (may help with multi-monitor stability)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Open source kernel module (still beta, use false for stable)
    open = false;
  };

  # Niri Configuration
  # Enable Niri window manager (scrollable-tiling compositor)
  programs.niri = {
    enable = true;
  };

  # Enable libinput with natural scrolling for mouse
  services.libinput = {
    enable = true;
    mouse = {
      naturalScrolling = true;
    };
  };

  # Power Management Configuration
  # Disable automatic suspend and hibernation
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";  # Don't suspend on lid close
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandlePowerKey = "ignore";
      IdleAction = "ignore";
      IdleActionSec = 0;
    };
  };

  # Stylix - System-wide theming
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
  };

  # Additional system packages for black-mesa
  environment.systemPackages = with pkgs; [
    swayidle  # Idle management for Wayland
    swaylock  # Screen locker for Wayland
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
