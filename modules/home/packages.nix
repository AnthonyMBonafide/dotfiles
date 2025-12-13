{ config, pkgs, ... }:

let
  discord-wayland = pkgs.symlinkJoin {
    name = "discord";
    paths = [ pkgs.discord ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/discord \
        --add-flags "--enable-features=UseOzonePlatform,WaylandWindowDecorations" \
        --add-flags "--ozone-platform=wayland"
    '';
  };
in
{
  # General packages and applications
  home.packages = with pkgs; [
    # Applications
    discord-wayland
    spotify

    # Steam is now enabled at system level in configuration.nix with proper Wayland support

    # Fonts are managed by Stylix in configuration.nix (JetBrainsMono Nerd Font, DejaVu Sans/Serif)

    # Note: The following macOS applications are typically better installed via Homebrew casks
    # because they need to be in /Applications or have special system integration:
    # - ghostty (Terminal - may not be in nixpkgs yet)
    # - firefox (Browser - for some reason nix install does not work on macOS)
    # These should be installed via on macOS:
    # brew install --cask spotify discord ghostty firefox
  ];
}
