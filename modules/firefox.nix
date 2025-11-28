{ config, pkgs, firefox-addons, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # Extensions via firefox-addons flake
      extensions.packages = with firefox-addons; [
        ublock-origin
        sponsorblock
        vimium
      ];

      # Search engines
      search = {
        force = true;
        default = "ddg";  # Use 'ddg' instead of 'DuckDuckGo'
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@np" ];
          };
          "NixOS Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@no" ];
          };
          "GitHub" = {
            urls = [{
              template = "https://github.com/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://github.com/favicon.ico";
            definedAliases = [ "@gh" ];
          };
        };
      };

      # Firefox preferences (about:config settings)
      settings = {
        # Privacy & Tracking Protection
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.resistFingerprinting" = false; # Can break some sites, enable if desired

        # Disable telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # Disable Firefox studies
        "app.shield.optoutstudies.enabled" = false;

        # Disable Pocket
        "extensions.pocket.enabled" = false;

        # Performance optimizations
        "gfx.webrender.all" = true;
        "gfx.webrender.enabled" = true;
        "layers.acceleration.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true; # Hardware video acceleration

        # UI Customization
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.tabs.warnOnClose" = false;

        # Dark mode settings
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.dark-private-windows" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

        # Enable extensions on all sites (including restricted domains)
        "extensions.webextensions.restrictedDomains" = "";
        "privacy.resistFingerprinting.block_mozAddonManager" = true;

        # Automatically enable installed extensions
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 15;

        # Smooth scrolling
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;

        # Auto-download updates but don't install them
        "app.update.auto" = false;

        # Don't ask to set as default browser
        "browser.shell.checkDefaultBrowser" = false;

        # Enable userChrome.css and userContent.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Enable U2F/FIDO2 support for hardware security keys (Yubikey) and Passkeys
        "security.webauthn.u2f" = true;
        "security.webauthn.webauthn_enable_softtoken" = true;  # Enable for Passkeys
        "security.webauthn.webauthn_enable_usbtoken" = true;
        "security.webauthn.ctap2" = true;
        "security.webauthn.enable_conditional_mediation" = true;
      };

      # Bookmarks
      # Note: Your existing bookmarks are backed up in ~/.mozilla/firefox/rmrxi92n.default.backup-YYYYMMDD
      # You can export them from Firefox (Ctrl+Shift+O → Import and Backup → Export)
      # and manually convert them to this format, or keep managing bookmarks manually
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "NixOS";
                tags = [ "nix" "linux" ];
                url = "https://nixos.org";
              }
              {
                name = "Home Manager";
                tags = [ "nix" "configuration" ];
                url = "https://nix-community.github.io/home-manager/";
              }
              {
                name = "GitHub";
                url = "https://github.com";
              }
            ];
          }
          {
            name = "Development";
            bookmarks = [
              {
                name = "NixOS Search";
                keyword = "nixpkgs";
                url = "https://search.nixos.org/packages";
              }
              {
                name = "NixOS Options";
                keyword = "nixopts";
                url = "https://search.nixos.org/options";
              }
            ];
          }
        ];
      };
    };
  };
}
