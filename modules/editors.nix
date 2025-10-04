{ config, pkgs, ... }:

{
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

  # Neovim Configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Neovim has its own complex Lua configuration
    # Instead of translating it to Nix, we'll symlink the entire config directory
    # This preserves your LazyVim setup and all plugins
  };

  # Symlink the entire Neovim configuration directory
  # This includes init.lua and the lua/ directory with all your configs
  xdg.configFile."nvim" = {
    source = ../.config/nvim;
    recursive = true;
  };

  # Helix Editor Configuration
  programs.helix = {
    enable = true;
  };

  # Symlink helix config files instead of reading them at build time
  xdg.configFile."helix/config.toml".source = ../.config/helix/config.toml;
  xdg.configFile."helix/languages.toml".source = ../.config/helix/languages.toml;
}
