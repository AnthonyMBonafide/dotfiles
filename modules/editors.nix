{ config, pkgs, flakeRoot, ... }:

{
  # Import Neovim configuration
  imports = [
    ./neovim.nix
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

  # Helix Editor Configuration
  programs.helix = {
    enable = true;
  };

  # Symlink helix config files instead of reading them at build time
  xdg.configFile."helix/config.toml".source = flakeRoot + /.config/helix/config.toml;
  xdg.configFile."helix/languages.toml".source = flakeRoot + /.config/helix/languages.toml;
}
