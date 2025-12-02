{ config, pkgs, ... }:

{
  # Plugin configurations

  # UI - theme is managed by stylix
  # Status line
  statusline.lualine = {
    enable = true;
  };

  # Terminal
  terminal.toggleterm.enable = true;

  # Treesitter
  treesitter.enable = true;

  # Telescope
  telescope.enable = true;

  # Completion
  autocomplete.nvim-cmp = {
    enable = true;
    mappings = {
      complete = "<C-Space>";
      close = "<C-e>";
      confirm = "<C-y>";
      next = "<Tab>";
      previous = "<S-Tab>";
    };
  };

  # Git integration
  git = {
    enable = true;
    gitsigns.enable = true;
  };

  # UI plugins
  ui = {
    smartcolumn.enable = true;
    noice.enable = true;
    colorizer.enable = true;
    fastaction.enable = true;
  };

  # Which-key - shows available keybindings
  binds.whichKey = {
    enable = true;
    register = {
      "<leader>f" = "+Find/Files";
      "<leader>s" = "+Search";
      "<leader>c" = "+Code";
      "<leader>r" = "+Refactor";
      "<leader>d" = "+Debug";
      "<leader>t" = "+Test";
      "<leader>x" = "+Diagnostics";
      "<leader>g" = "+Git";
    };
  };

  # Additional features
  autopairs.nvim-autopairs.enable = true;
  comments.comment-nvim.enable = true;

  # Extra plugins
  extraPlugins = with pkgs.vimPlugins; {
    alpha-nvim = {
      package = alpha-nvim;
      setup = ''
        local alpha = require('alpha')
        local dashboard = require('alpha.themes.dashboard')

        -- Set header
        dashboard.section.header.val = {
          "                                                     ",
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          "                                                     ",
        }

        -- Set menu
        dashboard.section.buttons.val = {
          dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
          dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
          dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
          dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
          dashboard.button("q", "  Quit", ":qa<CR>"),
        }

        -- Set footer
        local function footer()
          local total_plugins = #vim.tbl_keys(packer_plugins or {})
          local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
          return datetime .. "   " .. total_plugins .. " plugins"
        end

        dashboard.section.footer.val = footer()

        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        dashboard.opts.opts.noautocmd = true
        alpha.setup(dashboard.opts)
      '';
    };
    trouble-nvim = {
      package = trouble-nvim;
      setup = ''
        require('trouble').setup()
      '';
    };
    indent-blankline-nvim = {
      package = indent-blankline-nvim;
      setup = ''
        require('ibl').setup()
      '';
    };
    diffview-nvim = {
      package = diffview-nvim;
      setup = ''
        require('diffview').setup()
      '';
    };
    aerial-nvim = {
      package = aerial-nvim;
      setup = ''
        require('aerial').setup({
          on_attach = function(bufnr)
            vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
            vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
          end,
        })
      '';
    };
    undotree = {
      package = undotree;
    };
    luasnip = {
      package = luasnip;
      setup = ''
        local ls = require('luasnip')
        ls.config.set_config({
          history = true,
          updateevents = "TextChanged,TextChangedI",
        })
        -- Load friendly-snippets
        require('luasnip.loaders.from_vscode').lazy_load()
      '';
    };
    friendly-snippets = {
      package = friendly-snippets;
    };
    todo-comments = {
      package = todo-comments-nvim;
      setup = ''
        require('todo-comments').setup()
      '';
    };
    dressing = {
      package = dressing-nvim;
      setup = ''
        require('dressing').setup()
      '';
    };
    nvim-spectre = {
      package = nvim-spectre;
      setup = ''
        require('spectre').setup()
      '';
    };
    refactoring = {
      package = refactoring-nvim;
      setup = ''
        require('refactoring').setup()
      '';
    };
    vim-illuminate = {
      package = vim-illuminate;
      setup = ''
        require('illuminate').configure({
          providers = {
            'lsp',
            'treesitter',
            'regex',
          },
          delay = 100,
          under_cursor = true,
        })
      '';
    };
    yanky = {
      package = yanky-nvim;
      setup = ''
        require('yanky').setup()
        require('telescope').load_extension('yank_history')
      '';
    };
    mini-files = {
      package = mini-nvim;
      setup = ''
        require('mini.files').setup({
          windows = {
            preview = true,
            width_focus = 30,
            width_preview = 30,
          },
        })
      '';
    };
    flash = {
      package = flash-nvim;
      setup = ''
        require('flash').setup()
      '';
    };
    neotest = {
      package = neotest;
      setup = ''
        require('neotest').setup({
          adapters = {
            require('neotest-go'),
            require('neotest-rust'),
            require('neotest-zig'),
          },
          output = {
            enabled = true,
            open_on_run = false,
          },
        })
      '';
    };
    neotest-go = {
      package = neotest-go;
    };
    neotest-rust = {
      package = neotest-rust;
    };
    neotest-zig = {
      package = neotest-zig;
    };
    # DAP language adapters
    nvim-dap-go = {
      package = nvim-dap-go;
      setup = ''
        require('dap-go').setup()
      '';
    };
    # Rust DAP configuration (expects codelldb in PATH from project flake)
    rust-dap-config = {
      package = pkgs.vimUtils.buildVimPlugin {
        name = "rust-dap-config";
        src = pkgs.writeTextDir "after/plugin/rust-dap.lua" ''
          local dap = require('dap')

          -- Configure codelldb adapter (expects codelldb in PATH)
          dap.adapters.codelldb = {
            type = 'server',
            port = "''${port}",
            executable = {
              command = 'codelldb',
              args = {"--port", "''${port}"},
            }
          }

          -- Rust debug configuration
          dap.configurations.rust = {
            {
              name = "Launch",
              type = "codelldb",
              request = "launch",
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
              end,
              cwd = "''${workspaceFolder}",
              stopOnEntry = false,
              args = {},
            },
          }
        '';
      };
    };
  };
}
