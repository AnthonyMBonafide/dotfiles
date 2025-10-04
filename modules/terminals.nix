{ config, pkgs, ... }:

{
  # Ghostty Terminal
  # Ghostty might not have native home-manager support yet
  # We'll use xdg.configFile to symlink the config
  xdg.configFile."ghostty/config".source = ../.config/ghostty/config-2;
}
