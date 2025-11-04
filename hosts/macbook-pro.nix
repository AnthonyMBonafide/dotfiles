{ config, pkgs, ... }:

{
  # Host-specific configuration for MacBook Pro

  # System information
  home.username = "Anthony";
  home.homeDirectory = "/Users/Anthony";

  # System architecture is defined in flake.nix
  # This host uses: aarch64-darwin (Apple Silicon)

  # Host-specific packages (if any)
  home.packages = with pkgs; [
    # Add macOS-specific packages here if needed
  ];

  # macOS-specific configurations
  # Note: Some GUI apps are better installed via Homebrew:
  # brew install --cask spotify ghostty firefox bruno keepassxc
}
