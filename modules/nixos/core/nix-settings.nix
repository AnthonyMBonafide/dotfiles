{ config, pkgs, lib, ... }:

{
  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Automatically optimize the Nix store to save disk space
  # This deduplicates identical files (hard-linking them)
  nix.settings.auto-optimise-store = true;

  # Nix garbage collection is handled by programs.nh.clean
  # This is configured per-host if needed

  # Automatically clean up old boot entries to prevent /boot from filling up
  # This is critical on systems with small /boot partitions
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
  boot.loader.grub.configurationLimit = lib.mkDefault 10;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nh - a nice NixOS and Home Manager helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    # Default cleanup settings - can be overridden per-host
    # --keep-since 30d: Delete generations older than 30 days
    # --keep 3: Always keep at least the last 3 generations (even if older than 30 days)
    # Note: There's no "max 10 generations" limit - if you have 15 generations within 30 days, all are kept
    # To also limit total generations, you could periodically run: nix-collect-garbage --delete-generations +10
    clean.extraArgs = lib.mkDefault "--keep-since 30d --keep 3";
    flake = lib.mkDefault "/home/anthony/dotfiles";
  };

  # Set FLAKE environment variable for nh
  environment.sessionVariables = {
    FLAKE = lib.mkDefault "/home/anthony/dotfiles";
  };
}
