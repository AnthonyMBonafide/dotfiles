{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Import Neovim configuration
  imports = [
    ./nvf.nix
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
  ];
}
