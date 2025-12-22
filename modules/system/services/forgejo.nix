# Forgejo - Self-hosted Git service with CI/CD
# A lightweight software forge (fork of Gitea)
#
# This module provides a pre-configured setup for Forgejo on homelab servers.
# The actual service is provided by NixOS, this just sets sensible defaults.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homelab.services.forgejo;
in
{
  options.homelab.services.forgejo = {
    enable = mkEnableOption "Forgejo Git server with homelab defaults";

    domain = mkOption {
      type = types.str;
      default = "git.homelab.local";
      description = "Domain name for Forgejo";
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "HTTP port for Forgejo";
    };
  };

  config = mkIf cfg.enable {
    services.forgejo = {
      enable = true;

      settings = {
        server = {
          DOMAIN = cfg.domain;
          HTTP_PORT = cfg.port;
          ROOT_URL = "http://${cfg.domain}:${toString cfg.port}/";
        };

        service = {
          DISABLE_REGISTRATION = false;  # Set to true after creating your admin account
        };

        # Enable Actions (CI/CD)
        actions = {
          ENABLED = true;
        };
      };

      # Database backend (SQLite is default, can change to PostgreSQL for production)
      database.type = "sqlite3";
    };

    # Ensure the service starts after network is available
    systemd.services.forgejo = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
