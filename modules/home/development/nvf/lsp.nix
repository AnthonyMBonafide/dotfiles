{ config, pkgs, ... }:

{
  # LSP (Language Server Protocol) configuration

  lsp = {
    enable = true;
    formatOnSave = true;
    lspkind.enable = true;
  };

  # Language servers and language-specific configurations
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
}
