{ config, pkgs, ... }:

{
  # Terminal packages
  home.packages = with pkgs; [
    ghostty
  ];

  # Ghostty Terminal Configuration
  xdg.configFile."ghostty/config".text = ''
    theme = TokyoNight
    mouse-hide-while-typing = true
    background-blur-radius = 20
    window-decoration = true
    macos-option-as-alt = true
    background-opacity = 0.7

    font-size = 20
    keybind = shift+enter=text:\x1b\r
  '';
}
