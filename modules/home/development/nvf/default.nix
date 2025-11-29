{ config, pkgs, ... }:

{
  # Main Neovim configuration using nvf (NeoVim Flake)
  # Split into logical modules for better organization

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        # Set leader key
        globals.mapleader = " ";

        # Import modular configuration
        inherit (import ./options.nix { inherit config pkgs; })
          lineNumberMode clipboard luaConfigRC options;

        inherit (import ./lsp.nix { inherit config pkgs; })
          lsp languages;

        inherit (import ./dap.nix { inherit config pkgs; })
          debugger;

        inherit (import ./plugins.nix { inherit config pkgs; })
          statusline terminal treesitter telescope autocomplete git ui binds autopairs comments extraPlugins;

        inherit (import ./keybindings.nix { inherit config pkgs; })
          maps;
      };
    };
  };
}
