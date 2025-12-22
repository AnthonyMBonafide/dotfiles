# Jellyfin - Free Software Media System
# Media server for streaming movies, TV shows, music, and more
#
# This module provides a pre-configured setup for Jellyfin on homelab servers.
# The actual service is provided by NixOS, this just sets sensible defaults.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homelab.services.jellyfin;
in
{
  options.homelab.services.jellyfin = {
    enable = mkEnableOption "Jellyfin media server with homelab defaults";

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open firewall ports for Jellyfin";
    };
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = cfg.openFirewall;
    };

    # Create a directory for media storage
    # You'll want to mount your media drives here
    systemd.tmpfiles.rules = [
      "d /var/lib/jellyfin/media 0755 jellyfin jellyfin -"
      "d /var/lib/jellyfin/media/movies 0755 jellyfin jellyfin -"
      "d /var/lib/jellyfin/media/tv 0755 jellyfin jellyfin -"
      "d /var/lib/jellyfin/media/music 0755 jellyfin jellyfin -"
    ];

    # Ensure hardware acceleration is available
    # Uncomment and adjust based on your hardware
    # hardware.graphics.enable = true;  # For Intel Quick Sync
    # hardware.nvidia-container-toolkit.enable = true;  # For NVIDIA
  };
}
