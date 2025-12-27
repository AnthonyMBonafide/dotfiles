# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

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
    ../../modules/system/hardware/yubikey.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "lambda-core";

  # Enable YubiKey authentication and encryption support
  yubikey.auth.enable = true;
  yubikey.encryption.enable = true;
  # Note: Actual LUKS device configuration is in hardware-configuration.nix

  # Niri Configuration
  # Enable Niri window manager (scrollable-tiling compositor)
  programs.niri = {
    enable = true;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
