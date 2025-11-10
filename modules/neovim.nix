{ config, pkgs, ... }:

{
  # Neovim/LazyVim Configuration
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
          "marko-cerovac/material.nvim",
        }
      '';

      # Custom plugins from lua/plugins/
      copilot = ''
        return {
          "github/copilot.vim",
        }
      '';

      dap = ''
        return {
          "mfussenegger/nvim-dap",
          keys = {
            {
              "<leader>dO",
              function() require("dap").step_out() end,
              desc = "Step Out"
            },
            {
              "<leader>do",
              function() require("dap").step_over() end,
              desc = "Step Over"
            }
          }
        }
      '';

      gitworktree = ''
        return {
          "polarmutex/git-worktree.nvim",
          version = "^2",
          dependencies = { "nvim-lua/plenary.nvim" },
          enabled = true,
          config = function()
            require("telescope").load_extension("git_worktree")

            vim.keymap.set("n", "gW", function()
              require("telescope").extensions.git_worktree.git_worktree()
            end, { desc = "Worktrees" })
          end,
        }
      '';

      go = ''
        return {
          "ray-x/go.nvim",
          dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter"
          },
          opts = {},
          config = function(lp, opts)
            require("go").setup(opts)
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
              pattern = "*.go",
              callback = function()
                require("go.format").goimports()
              end,
              group = format_sync_grp,
            })
          end,
          event = { "CmdlineEnter" },
          ft = { "go", "gomod" },
          build = ':lua require("go.install").update_all_sync()',
        }
      '';

      kulala = ''
        return {
          "mistweaverco/kulala.nvim",
          ft = "http",
          keys = {
            { "<leader>R", "", desc = "+Rest", ft = "http" },
            { "<leader>Rb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open scratchpad", ft = "http" },
            { "<leader>Rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL", ft = "http" },
            { "<leader>Rs", "<cmd>lua require('kulala').run()<cr>", desc = "Send the request", ft = "http" },
          },
          opts = {},
        }
      '';

      lazyjj = ''
        return {
          "swaits/lazyjj.nvim",
          dependencies = "nvim-lua/plenary.nvim",
          opts = {},
        }
      '';

      marko = ''
        return {
          "mohseenrm/marko.nvim",
          config = function()
            require("marko").setup()
          end,
        }
      '';

      minifiles = ''
        return {
          "nvim-mini/mini.files",
          opts = {
            windows = {
              preview = true,
              width_focus = 30,
              width_preview = 30,
            },
          },
          keys = {
            {
              "<leader>fm",
              function()
                require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
              end,
              desc = "Open mini.files (Directory of Current File)",
            },
            {
              "<leader>fM",
              function()
                require("mini.files").open(vim.uv.cwd(), true)
              end,
              desc = "Open mini.files (cwd)",
            },
          },
        }
      '';

      neotest = ''
        return {
          "nvim-neotest/neotest",
          opts = {
            output = {
              enabled = true,
              open_on_run = false,
            },
          },
        }
      '';

      neotree = ''
        return {
          { "nvim-neo-tree/neo-tree.nvim", enabled = false },
        }
      '';

      octo = ''
        return {
          "pwntester/octo.nvim",
          opts = {
            picker = "snacks",
          },
        }
      '';

      snacks = ''
        return {
          "snacks.nvim",
          opts = {
            dashboard = {
              preset = {
                pick = function(cmd, opts)
                  return LazyVim.pick(cmd, opts)()
                end,
                header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                keys = {
                   { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                   { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                   { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                   { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                   { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                   { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                   { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                   { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                   { icon = " ", key = "q", desc = "Quit", action = ":qa" },                },
              },
            },
          },
        }
      '';

      tabline = ''
        return {
          { "akinsho/bufferline.nvim", enabled = false },
        }
      '';

      telescope = ''
        return {
          { "nvim-telescope/telescope.nvim" },
        }
      '';

      treesitter = ''
        return {
          "nvim-treesitter/nvim-treesitter",
          opts = {
            ensure_installed = {
              "bash",
              "json",
              "lua",
              "markdown",
              "markdown_inline",
              "yaml",
              "go",
              "rust",
              "zig",
            },
          },
        }
      '';

      trouble = ''
        return {
          "folke/trouble.nvim",
          cmd = { "Trouble" },
          opts = {
            modes = {
              symbols = {
                win = {
                  type = "split",
                  relative = "win",
                  position = "right",
                  size = 0.45,
                },
              },
            },
          },
        }
      '';

      rust = ''
        return {
          "neovim/nvim-lspconfig",
          opts = {
            servers = {
              rust_analyzer = {
                settings = {
                  ["rust-analyzer"] = {
                    cargo = {
                      allFeatures = true,
                      loadOutDirsFromCheck = true,
                      buildScripts = {
                        enable = true,
                      },
                    },
                    checkOnSave = {
                      command = "clippy",
                    },
                    procMacro = {
                      enable = true,
                    },
                  },
                },
              },
            },
          },
        }
      '';

      undotree = ''
        return {
          "Ruskei/undotree",
          dependencies = "nvim-lua/plenary.nvim",
          config = true,
          keys = {
            { "<leader>su", "<cmd>lua require('undotree').toggle()<cr>" }
          },
        }
      '';
    };

    extras = {
      # Core coding plugins
      coding.mini-surround.enable = true;
      coding.yanky.enable = true;

      # Editor enhancements
      editor.mini-diff.enable = true;
      editor.mini-files.enable = true;
      editor.overseer.enable = true;

      # Language support
      lang.nix.enable = true;
      lang.docker.enable = true;
      lang.git.enable = true;
      lang.json.enable = true;
      lang.markdown.enable = true;
      # lang.python.enable = true;
      # lang.sql.enable = true;  # Disabled: vim-dadbod has hash mismatch
      lang.toml.enable = true;
      lang.yaml.enable = true;
      lang.zig.enable = true;

      lang.rust = {
        enable = true;
        installDependencies = false;
        installRuntimeDependencies = false;
      };

      lang.go = {
        enable = true;
        installDependencies = false;
        installRuntimeDependencies = false;
      };

      # Testing and debugging
      test.core.enable = true;
      dap.core.enable = true;

      # Utilities
      util.dot.enable = true;
      util.octo.enable = true;
      util.rest.enable = true;
    };

    # Additional packages (optional)
    extraPackages = with pkgs; [
      tree-sitter    # Tree-sitter CLI
      gcc            # C compiler for treesitter parsers
      nixd           # Nix LSP
      alejandra      # Nix formatter
      statix         # Nix linter
      rust-analyzer  # Rust LSP (needs to be explicit for PATH)
      bacon          # Rust background compiler
      lldb           # Debug adapter for Rust/C/C++
      vscode-extensions.vadimcn.vscode-lldb  # CodeLLDB adapter for DAP
    ];

    # Only needed for languages not covered by LazyVim
    # treesitterParsers = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
    #   templ     # Go templ files
    # ];
  };

  # # Set Neovim as default editor
  # programs.neovim = {
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  # };
}
