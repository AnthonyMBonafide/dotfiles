{ config, pkgs, ... }:

{
  # Debug Adapter Protocol (DAP) configuration

  debugger = {
    nvim-dap = {
      enable = true;
      ui.enable = true;
    };
  };
}
