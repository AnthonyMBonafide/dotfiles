{ config, pkgs, ... }:

{
  # Alacritty Terminal
  programs.alacritty = {
    enable = true;
  };

  # Symlink the alacritty config file instead of reading it at build time
  xdg.configFile."alacritty/alacritty.toml".source = ../.config/alacritty/alacritty.toml;

    # Ghostty Terminal
  # Ghostty might not have native home-manager support yet
  # We'll use xdg.configFile to symlink the config
  xdg.configFile."ghostty/config".source = ../.config/ghostty/config;

  # Zellij Terminal Multiplexer
  # Zellij uses KDL format which isn't natively supported by Nix
  # We'll symlink the entire config directory
  xdg.configFile."zellij/config.kdl".source = ../.config/zellij/config.kdl;

  # Zellij plugin - if the plugin file exists, symlink it
  # The autolock plugin is referenced in the config
  # Note: Comment this out if the plugin file doesn't exist
  xdg.configFile."zellij/plugins/zellij-autolock.wasm".source = ../.config/zellij/plugins/zellij-autolock.wasm;
}
