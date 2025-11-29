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
}
