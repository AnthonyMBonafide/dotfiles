{ config, pkgs, flakeRoot, ... }:

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

  # LazyVim Configuration
  programs.lazyvim = {
  enable = true;
  installCoreDependencies = true;
  config = {
      options = ''
        vim.opt.swapfile = false
      '';

      keymaps = ''
        vim.keymap.set("i", "jk", "<Esc>")
      '';
    };

    plugins = {
      colorscheme = ''
        return {
          "catppuccin/nvim",
          opts = { flavour = "mocha" },
        }
      '';
    };
    
  extras = {
    lang.nix.enable = true;
    test.core = {
        enable = true;
    };

    lang.rust = {
      enable = true;
      installDependencies = true;
      installRuntimeDependencies = true;
    };
    lang.go = {
      enable = true;
      installDependencies = true;        # Install gopls, gofumpt, etc.
      installRuntimeDependencies = true; # Install go compiler
    };
  };

  # Additional packages (optional)
  extraPackages = with pkgs; [
    tree-sitter  # Tree-sitter CLI
    nixd         # Nix LSP
    alejandra    # Nix formatter
  ];

  # Only needed for languages not covered by LazyVim
  treesitterParsers = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
    templ     # Go templ files
  ];
};
  # # Set Neovim as default editor
  # programs.neovim = {
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  # };

  # Helix Editor Configuration
  programs.helix = {
    enable = true;
  };

  # Symlink helix config files instead of reading them at build time
  xdg.configFile."helix/config.toml".source = flakeRoot + /.config/helix/config.toml;
  xdg.configFile."helix/languages.toml".source = flakeRoot + /.config/helix/languages.toml;
}
