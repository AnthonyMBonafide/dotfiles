{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Import Neovim configuration
  imports = [
    ./development/nvf
  ];

  # Editor and writing tools
  home.packages = with pkgs; [
    # Lua package manager (for Neovim)
    luarocks

    # Linters and formatters
    markdownlint-cli
    # markdown-toc  # May need to be installed via npm
    nodePackages.prettier
    sqlfluff

    # Clipboard utilities for Wayland
    wl-clipboard  # Provides wl-copy and wl-paste for Wayland clipboard access
  ];
}
