{ config, pkgs, ... }:

{
  # Basic Neovim options and settings

  # Line number display
  lineNumberMode = "relNumber";

  # Clipboard configuration - use system clipboard
  clipboard = {
    providers.wl-copy.enable = true;
  };

  # Use system clipboard by default
  # Delay clipboard setup to avoid "Nothing is copied" error on startup
  luaConfigRC.clipboard = ''
    vim.schedule(function()
      vim.opt.clipboard:append("unnamedplus")
    end)
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
}
