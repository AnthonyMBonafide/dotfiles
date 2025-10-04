{ config, pkgs, ... }:

{
  # Import all module configurations
  imports = [
    ./modules/shell.nix
    ./modules/terminals.nix
    ./modules/development.nix
    ./modules/editors.nix
    ./modules/packages.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "claude-code"
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "Anthony";
  home.homeDirectory = "/Users/Anthony";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Additional packages can be added here or in the individual modules
  # Most packages are now organized in modules/
  home.packages = with pkgs; [
    # Add any additional one-off packages here
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG base directories
  xdg.enable = true;
}
