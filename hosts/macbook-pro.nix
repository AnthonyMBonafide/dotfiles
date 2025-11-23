{ config, pkgs, ... }:

{
  # Host-specific configuration for MacBook Pro

  # System information
  home.username = "Anthony";
  home.homeDirectory = "/Users/Anthony";

  # System architecture is defined in flake.nix
  # This host uses: aarch64-darwin (Apple Silicon)

  # Allow unfree packages for standalone home-manager
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "claude-code"
  ];

  # Enable automatic garbage collection on macOS
  # (disabled by default on NixOS to avoid conflict with programs.nh.clean)
  nix.gc.automatic = true;

  # Host-specific packages (if any)
  home.packages = with pkgs; [
    # Add macOS-specific packages here if needed
  ];

  # macOS-specific configurations
  # Note: Some GUI apps are better installed via Homebrew:
  # brew install --cask spotify ghostty firefox bruno keepassxc
}
