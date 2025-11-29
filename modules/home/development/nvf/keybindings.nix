{ config, pkgs, ... }:

{
  # Neovim key mappings organized by mode

  maps = {
    # Insert mode mappings
    insert = {
      # Exit insert mode with jk
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

    # Normal mode mappings
    normal = {
      # Better window navigation
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

    # Visual mode mappings
    visual = {
      # Flash visual mode mappings
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

    # Operator mode mappings
    operator = {
      # Flash operator mode mappings
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
}
