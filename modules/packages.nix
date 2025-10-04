{ config, pkgs, ... }:

{
  # General packages, fonts, and applications
  home.packages = with pkgs; [
    podman
    # Fonts
    # Nerd Fonts are now separate packages in the nerd-fonts namespace
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu

    # Note: The following macOS applications are typically better installed via Homebrew casks
    # because they need to be in /Applications or have special system integration:
    # - spotify (Music streaming)
    # - ghostty (Terminal - may not be in nixpkgs yet)
    # - firefox (Browser - for some reason nix install does not work)
    # These should be installed via:
    # brew install --cask spotify ghostty firefox
  ];

  # Font configuration
  fonts.fontconfig.enable = true;
}
