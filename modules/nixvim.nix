{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Set leader key explicitly before any plugins load
    extraConfigLuaPre = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
    '';

    # Set leader key in globals as well
    globals.mapleader = " ";
    globals.maplocalleader = " ";

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

      # Leader key mappings for Telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options = {
          desc = "Find files";
        };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options = {
          desc = "Live grep";
        };
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options = {
          desc = "Find buffers";
        };
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
        options = {
          desc = "Help tags";
        };
      }

      # Leader key mappings for nvim-tree
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<cr>";
        options = {
          desc = "Toggle file explorer";
        };
      }

      # Leader key mappings for LSP
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options = {
          desc = "Code action";
        };
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
        options = {
          desc = "Rename symbol";
        };
      }
      {
        mode = "n";
        key = "<leader>f";
        action = "<cmd>lua vim.lsp.buf.format()<cr>";
        options = {
          desc = "Format document";
        };
      }

      # DAP (Debug Adapter Protocol) keymaps
      {
        mode = "n";
        key = "<leader>dO";
        action = "<cmd>lua require('dap').step_out()<cr>";
        options = {
          desc = "Step Out";
        };
      }
      {
        mode = "n";
        key = "<leader>do";
        action = "<cmd>lua require('dap').step_over()<cr>";
        options = {
          desc = "Step Over";
        };
      }

      # Git worktree keymap
      {
        mode = "n";
        key = "gW";
        action = "<cmd>lua require('telescope').extensions.git_worktree.git_worktree()<cr>";
        options = {
          desc = "Git Worktrees";
        };
      }

      # REST client (kulala) keymaps - only active for .http files
      {
        mode = "n";
        key = "<leader>Rb";
        action = "<cmd>lua require('kulala').scratchpad()<cr>";
        options = {
          desc = "Open scratchpad";
        };
      }
      {
        mode = "n";
        key = "<leader>Rc";
        action = "<cmd>lua require('kulala').copy()<cr>";
        options = {
          desc = "Copy as cURL";
        };
      }
      {
        mode = "n";
        key = "<leader>Rs";
        action = "<cmd>lua require('kulala').run()<cr>";
        options = {
          desc = "Send the request";
        };
      }

      # Mini.files keymaps
      {
        mode = "n";
        key = "<leader>fm";
        action = "<cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0), true)<cr>";
        options = {
          desc = "Open mini.files (current file dir)";
        };
      }
      {
        mode = "n";
        key = "<leader>fM";
        action = "<cmd>lua require('mini.files').open(vim.uv.cwd(), true)<cr>";
        options = {
          desc = "Open mini.files (cwd)";
        };
      }

      # Undotree keymap
      {
        mode = "n";
        key = "<leader>su";
        action = "<cmd>UndotreeToggle<cr>";
        options = {
          desc = "Toggle undotree";
        };
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
      web-devicons.enable = true;
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

    # Extra plugins not available as nixvim modules
    extraPlugins = with pkgs.vimPlugins; [
      undotree  # Visualize undo history (classic vim plugin, not lua)
    ];
  };
}
