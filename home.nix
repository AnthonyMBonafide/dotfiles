{ config, pkgs, ... }:

{
  # Import all module configurations
  imports = [
    ./modules/shell.nix
    ./modules/ssh.nix
    ./modules/terminals.nix
    ./modules/development.nix
    ./modules/editors.nix
    ./modules/packages.nix
    ./modules/firefox.nix
  ];

  # Allow unfree packages
  # Note: This is set in host-specific configs for standalone home-manager
  # On NixOS, this is handled by the system config

  # Home Manager needs a bit of information about you and the paths it should manage
  # These are now set in host-specific configurations (hosts/*.nix)
  # home.username is set by host config
  # home.homeDirectory is set by host config

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Additional packages can be added here or in the individual modules
  # Most packages are now organized in modules/
  home.packages = with pkgs; [
    # Add any additional one-off packages here
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG base directories
  xdg.enable = true;

  # Nix garbage collection and store optimization
  # These settings help manage disk usage by automatically cleaning up old/unused packages
  nix = {
    package = pkgs.lib.mkDefault pkgs.nix;

    gc = {
      # Automatically run garbage collection to free up disk space
      automatic = true;

      # Schedule: uses systemd.time calendar event format
      # "weekly" = once per week, "daily" = once per day
      # Weekly is a good balance - not too aggressive, prevents accumulation
      dates = "weekly";

      # Delete derivations and outputs older than 30 days
      # Adjust based on your needs:
      #   - 7d: Aggressive, saves space, but harder to rollback
      #   - 30d: Balanced (recommended for most users)
      #   - 90d: Conservative, easier to rollback, uses more space
      options = "--delete-older-than 30d";

      # Alternative: Keep last N generations instead of time-based
      # Uncomment to use generation-based cleanup instead:
      # options = "--delete-generations +5";
    };

    settings = {
      # Automatically deduplicate identical files in the store to save space
      # This can save significant disk space (often 10-30% reduction)
      auto-optimise-store = true;

      # Trigger garbage collection automatically when free space is low
      # min-free: Run GC when available space falls below this threshold (in bytes)
      # max-free: Run GC until this much space is available
      # Uncomment if you want disk-space-based GC (in addition to time-based):
      # min-free = ${toString (1024 * 1024 * 1024)};    # 1 GB
      # max-free = ${toString (5 * 1024 * 1024 * 1024)}; # 5 GB
    };
  };

 }
