{ config, pkgs, ... }:

{
  # Karabiner Elements Configuration
  # Karabiner is a macOS-specific keyboard customization tool
  # It uses JSON configuration which we'll symlink

  # Main Karabiner configuration
  xdg.configFile."karabiner/karabiner.json".source = ../.config/karabiner/karabiner.json;

  # Complex modifications
  xdg.configFile."karabiner/assets/complex_modifications" = {
    source = ../.config/karabiner/assets/complex_modifications;
    recursive = true;
  };

  # Note: Karabiner Elements needs to be installed separately on macOS
  # It's not available through Nix on macOS as it requires system extensions
  # Install via: brew install --cask karabiner-elements

  # Optional: Symlink automatic backups if you want to preserve them
  # Uncomment if needed:
  # xdg.configFile."karabiner/automatic_backups" = {
  #   source = ../.config/karabiner/automatic_backups;
  #   recursive = true;
  # };
}
