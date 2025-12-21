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

  spotify-fixed = pkgs.symlinkJoin {
    name = "spotify";
    paths = [ pkgs.spotify ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [
          pkgs.libayatana-appindicator
          pkgs.libdbusmenu
          pkgs.gtk3
          pkgs.pango
          pkgs.harfbuzz
          pkgs.atk
          pkgs.cairo
          pkgs.gdk-pixbuf
          pkgs.glib
          pkgs.alsa-lib
          pkgs.gcc.cc.lib
          pkgs.xorg.libX11
          pkgs.xorg.libXcomposite
          pkgs.xorg.libXdamage
          pkgs.xorg.libXext
          pkgs.xorg.libXfixes
          pkgs.xorg.libXrandr
          pkgs.xorg.libxcb
          pkgs.libxkbcommon
          pkgs.mesa
          pkgs.libgbm
          pkgs.expat
          pkgs.systemd
          pkgs.nspr
          pkgs.nss
          pkgs.dbus
          pkgs.cups
          pkgs.at-spi2-atk
          pkgs.at-spi2-core
        ]}"
    '';
  };
in
{
  # General packages and applications
  home.packages = with pkgs; [
    # Applications
    discord-wayland
    spotify-fixed

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
