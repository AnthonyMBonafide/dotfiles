{ config, pkgs, ... }:

{
  # General packages, fonts, and applications
  home.packages = with pkgs; [
    podman

    # Applications
    discord
    spotify

    # Fonts
    # Nerd Fonts are now separate packages in the nerd-fonts namespace
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu

    # Note: The following macOS applications are typically better installed via Homebrew casks
    # because they need to be in /Applications or have special system integration:
    # - ghostty (Terminal - may not be in nixpkgs yet)
    # - firefox (Browser - for some reason nix install does not work on macOS)
    # These should be installed via on macOS:
    # brew install --cask spotify discord ghostty firefox
  ];

  # Font configuration
  fonts.fontconfig.enable = true;
}
