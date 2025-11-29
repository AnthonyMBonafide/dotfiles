{ config, pkgs, ... }:

{
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        # Set leader key
        globals.mapleader = " ";

        # Options
        lineNumberMode = "relNumber";

        # Clipboard configuration - use system clipboard
        clipboard = {
          providers.wl-copy.enable = true;
        };

        # Use system clipboard by default
        luaConfigRC.clipboard = ''
          vim.opt.clipboard:append("unnamedplus")
        '';

        # Tab and indent settings
        options = {
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          autoindent = true;
          cmdheight = 1;

          # Search settings
          ignorecase = true;  # Case insensitive search by default
          smartcase = true;   # Case sensitive when search contains capitals

          # Undo persistence
          undofile = true;
        };

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

        # LSP
        lsp = {
          enable = true;
          formatOnSave = true;
          lspkind.enable = true;
        };

        # Debugger
        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        # Language servers
        languages = {
          nix.enable = true;
          rust = {
            enable = true;
            lsp.enable = true;
          };
          go = {
            enable = true;
            lsp.enable = true;
          };
          zig = {
            enable = true;
            lsp.enable = true;
          };
        };

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
        binds.whichKey.enable = true;

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

        # Key mappings
        maps = {
          # Exit insert mode with jk
          insert = {
            "jk" = {
              action = "<Esc>";
              desc = "Exit insert mode";
            };

            # LuaSnip navigation
            "<C-j>" = {
              action = "<cmd>lua require('luasnip').jump(1)<cr>";
              desc = "Jump to next snippet placeholder";
            };
            "<C-k>" = {
              action = "<cmd>lua require('luasnip').jump(-1)<cr>";
              desc = "Jump to previous snippet placeholder";
            };
          };

          # Better window navigation
          normal = {
            "<C-h>" = {
              action = "<C-w>h";
              desc = "Move to left window";
            };
            "<C-j>" = {
              action = "<C-w>j";
              desc = "Move to bottom window";
            };
            "<C-k>" = {
              action = "<C-w>k";
              desc = "Move to top window";
            };
            "<C-l>" = {
              action = "<C-w>l";
              desc = "Move to right window";
            };

            # Clear search highlighting
            "<Esc>" = {
              action = "<cmd>nohlsearch<cr>";
              desc = "Clear search highlighting";
            };

            # Telescope keymaps
            "<leader>ff" = {
              action = "<cmd>Telescope find_files<cr>";
              desc = "Find files";
            };
            "<leader>fr" = {
              action = "<cmd>Telescope oldfiles<cr>";
              desc = "Recent files";
            };
            "<leader>fg" = {
              action = "<cmd>Telescope live_grep<cr>";
              desc = "Live grep";
            };
            "<leader>fb" = {
              action = "<cmd>Telescope buffers<cr>";
              desc = "Find buffers";
            };
            "<leader>fh" = {
              action = "<cmd>Telescope help_tags<cr>";
              desc = "Help tags";
            };

            # File explorer - open mini.files at current file directory
            "<leader>e" = {
              action = "<cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0), true)<cr>";
              desc = "Toggle file explorer";
            };

            # LSP keymaps
            "gd" = {
              action = "<cmd>Telescope lsp_definitions<cr>";
              desc = "Go to definition";
            };
            "gD" = {
              action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
              desc = "Go to declaration";
            };
            "gr" = {
              action = "<cmd>Telescope lsp_references<cr>";
              desc = "Go to references";
            };
            "gi" = {
              action = "<cmd>Telescope lsp_implementations<cr>";
              desc = "Go to implementation";
            };
            "gt" = {
              action = "<cmd>Telescope lsp_type_definitions<cr>";
              desc = "Go to type definition";
            };
            "gs" = {
              action = "<cmd>Telescope lsp_document_symbols<cr>";
              desc = "Document symbols";
            };
            "gS" = {
              action = "<cmd>Telescope lsp_workspace_symbols<cr>";
              desc = "Workspace symbols";
            };
            "K" = {
              action = "<cmd>lua vim.lsp.buf.hover()<cr>";
              desc = "Hover documentation";
            };
            "<leader>ca" = {
              action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
              desc = "Code action";
            };
            "<leader>rn" = {
              action = "<cmd>lua vim.lsp.buf.rename()<cr>";
              desc = "Rename symbol";
            };
            "<leader>f" = {
              action = "<cmd>lua vim.lsp.buf.format()<cr>";
              desc = "Format document";
            };

            # DAP (Debug Adapter Protocol) keymaps
            "<leader>db" = {
              action = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
              desc = "Toggle breakpoint";
            };
            "<leader>dB" = {
              action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>";
              desc = "Set conditional breakpoint";
            };
            "<leader>dc" = {
              action = "<cmd>lua require('dap').continue()<cr>";
              desc = "Continue";
            };
            "<leader>di" = {
              action = "<cmd>lua require('dap').step_into()<cr>";
              desc = "Step into";
            };
            "<leader>do" = {
              action = "<cmd>lua require('dap').step_over()<cr>";
              desc = "Step over";
            };
            "<leader>dO" = {
              action = "<cmd>lua require('dap').step_out()<cr>";
              desc = "Step out";
            };
            "<leader>dr" = {
              action = "<cmd>lua require('dap').repl.toggle()<cr>";
              desc = "Toggle REPL";
            };
            "<leader>dl" = {
              action = "<cmd>lua require('dap').run_last()<cr>";
              desc = "Run last";
            };
            "<leader>dt" = {
              action = "<cmd>lua require('dap').terminate()<cr>";
              desc = "Terminate";
            };
            "<leader>du" = {
              action = "<cmd>lua require('dapui').toggle()<cr>";
              desc = "Toggle DAP UI";
            };

            # Mini.files keymaps
            "<leader>fm" = {
              action = "<cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0), true)<cr>";
              desc = "Open mini.files (current file dir)";
            };
            "<leader>fM" = {
              action = "<cmd>lua require('mini.files').open(vim.uv.cwd(), true)<cr>";
              desc = "Open mini.files (cwd)";
            };

            # Undotree
            "<leader>su" = {
              action = "<cmd>UndotreeToggle<cr>";
              desc = "Toggle undotree";
            };

            # Flash - quick navigation
            "s" = {
              action = "<cmd>lua require('flash').jump()<cr>";
              desc = "Flash jump";
            };
            "S" = {
              action = "<cmd>lua require('flash').treesitter()<cr>";
              desc = "Flash treesitter";
            };

            # Neotest - testing framework
            "<leader>tn" = {
              action = "<cmd>lua require('neotest').run.run()<cr>";
              desc = "Run nearest test";
            };
            "<leader>tf" = {
              action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>";
              desc = "Run current file tests";
            };
            "<leader>tD" = {
              action = "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>";
              desc = "Debug nearest test";
            };
            "<leader>ts" = {
              action = "<cmd>lua require('neotest').summary.toggle()<cr>";
              desc = "Toggle test summary";
            };
            "<leader>to" = {
              action = "<cmd>lua require('neotest').output.open({ enter = true })<cr>";
              desc = "Show test output";
            };
            "<leader>tO" = {
              action = "<cmd>lua require('neotest').output_panel.toggle()<cr>";
              desc = "Toggle test output panel";
            };
            "<leader>tx" = {
              action = "<cmd>lua require('neotest').run.stop()<cr>";
              desc = "Stop nearest test";
            };

            # Trouble keymaps
            "<leader>xx" = {
              action = "<cmd>Trouble diagnostics toggle<cr>";
              desc = "Diagnostics (Trouble)";
            };
            "<leader>xX" = {
              action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
              desc = "Buffer Diagnostics (Trouble)";
            };
            "<leader>cs" = {
              action = "<cmd>Trouble symbols toggle focus=false<cr>";
              desc = "Symbols (Trouble)";
            };
            "<leader>cl" = {
              action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
              desc = "LSP Definitions / references / ... (Trouble)";
            };
            "<leader>xL" = {
              action = "<cmd>Trouble loclist toggle<cr>";
              desc = "Location List (Trouble)";
            };
            "<leader>xQ" = {
              action = "<cmd>Trouble qflist toggle<cr>";
              desc = "Quickfix List (Trouble)";
            };

            # Diffview keymaps
            "<leader>gd" = {
              action = "<cmd>DiffviewOpen<cr>";
              desc = "Open diffview";
            };
            "<leader>gD" = {
              action = "<cmd>DiffviewClose<cr>";
              desc = "Close diffview";
            };
            "<leader>gh" = {
              action = "<cmd>DiffviewFileHistory %<cr>";
              desc = "File history";
            };
            "<leader>gH" = {
              action = "<cmd>DiffviewFileHistory<cr>";
              desc = "Project history";
            };

            # Aerial keymaps
            "<leader>a" = {
              action = "<cmd>AerialToggle!<cr>";
              desc = "Toggle aerial";
            };

            # Todo-comments keymaps
            "<leader>xt" = {
              action = "<cmd>TodoTrouble<cr>";
              desc = "Todo (Trouble)";
            };
            "<leader>xT" = {
              action = "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>";
              desc = "Todo/Fix/Fixme (Trouble)";
            };
            "<leader>st" = {
              action = "<cmd>TodoTelescope<cr>";
              desc = "Todo (Telescope)";
            };
            "<leader>sT" = {
              action = "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>";
              desc = "Todo/Fix/Fixme (Telescope)";
            };

            # Nvim-spectre keymaps (search and replace)
            "<leader>sr" = {
              action = "<cmd>lua require('spectre').open()<cr>";
              desc = "Replace in files (Spectre)";
            };
            "<leader>sw" = {
              action = "<cmd>lua require('spectre').open_visual({select_word=true})<cr>";
              desc = "Replace word under cursor";
            };
            "<leader>sp" = {
              action = "<cmd>lua require('spectre').open_file_search()<cr>";
              desc = "Replace in current file";
            };

            # Yanky keymaps (yank history)
            "p" = {
              action = "<Plug>(YankyPutAfter)";
              desc = "Put after";
            };
            "P" = {
              action = "<Plug>(YankyPutBefore)";
              desc = "Put before";
            };
            "<leader>p" = {
              action = "<cmd>Telescope yank_history<cr>";
              desc = "Yank history";
            };
          };

          # Flash visual mode mappings
          visual = {
            "s" = {
              action = "<cmd>lua require('flash').jump()<cr>";
              desc = "Flash jump";
            };
            "S" = {
              action = "<cmd>lua require('flash').treesitter()<cr>";
              desc = "Flash treesitter";
            };

            # Refactoring keymaps (visual mode)
            "<leader>re" = {
              action = "<Esc><cmd>lua require('refactoring').refactor('Extract Function')<cr>";
              desc = "Extract function";
            };
            "<leader>rf" = {
              action = "<Esc><cmd>lua require('refactoring').refactor('Extract Function To File')<cr>";
              desc = "Extract function to file";
            };
            "<leader>rv" = {
              action = "<Esc><cmd>lua require('refactoring').refactor('Extract Variable')<cr>";
              desc = "Extract variable";
            };
            "<leader>ri" = {
              action = "<Esc><cmd>lua require('refactoring').refactor('Inline Variable')<cr>";
              desc = "Inline variable";
            };

            # Spectre visual mode keymap
            "<leader>sr" = {
              action = "<cmd>lua require('spectre').open_visual()<cr>";
              desc = "Replace selection (Spectre)";
            };
          };

          # Flash operator mode mappings
          operator = {
            "s" = {
              action = "<cmd>lua require('flash').jump()<cr>";
              desc = "Flash jump";
            };
            "S" = {
              action = "<cmd>lua require('flash').treesitter()<cr>";
              desc = "Flash treesitter";
            };
          };
        };
      };
    };
  };
}
