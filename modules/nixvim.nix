{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Global options
    opts = {
      number = true;
      relativenumber = true;
      swapfile = false;

      # Indentation
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      # Search
      ignorecase = true;
      smartcase = true;

      # UI
      termguicolors = true;
      signcolumn = "yes";
      cursorline = true;

      # Clipboard
      clipboard = "unnamedplus";
    };

    # Global settings
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # Key mappings
    keymaps = [
      # Exit insert mode with jk
      {
        mode = "i";
        key = "jk";
        action = "<Esc>";
      }

      # Better window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
      }
    ];

    # Colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    # Plugins
    plugins = {
      # Essential plugins
      lualine.enable = true;
      nvim-tree.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      which-key.enable = true;

      # Git
      gitsigns.enable = true;
      fugitive.enable = true;

      # LSP
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          gopls.enable = true;
          zls.enable = true;
        };
      };

      # Completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "alejandra" ];
            rust = [ "rustfmt" ];
            go = [ "gofmt" ];
          };
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 500;
          };
        };
      };

      # Additional utilities
      comment.enable = true;
      nvim-autopairs.enable = true;
      indent-blankline.enable = true;
    };

    # Extra packages to install
    extraPackages = with pkgs; [
      # Language servers
      nixd
      rust-analyzer
      gopls
      zls

      # Formatters
      alejandra
      rustfmt

      # Other tools
      ripgrep
      fd
      gcc
    ];
  };
}
