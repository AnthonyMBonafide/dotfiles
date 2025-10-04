{ config, pkgs, ... }:

{
  # General packages, fonts, and applications
  home.packages = with pkgs; [
    # AI/ML
    ollama

    # Browsers
    firefox

    # Fonts
    # Nerd Fonts are now separate packages in the nerd-fonts namespace
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu

    # Note: The following macOS applications are typically better installed via Homebrew casks
    # because they need to be in /Applications or have special system integration:
    # - bruno (API client)
    # - keepassxc (Password manager)
    # - meetingbar (Menu bar calendar)
    # - scroll-reverser (Mouse/trackpad utility)
    # - spotify (Music streaming)
    # - ghostty (Terminal - may not be in nixpkgs yet)
    #
    # These should be installed via:
    # brew install --cask bruno keepassxc meetingbar scroll-reverser spotify ghostty
  ];

  # Font configuration
  fonts.fontconfig.enable = true;
}
