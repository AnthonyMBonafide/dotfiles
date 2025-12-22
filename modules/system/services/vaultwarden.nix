# Vaultwarden - Unofficial Bitwarden compatible server
# Lightweight password manager server written in Rust
#
# This module provides a pre-configured setup for Vaultwarden on homelab servers.
# The actual service is provided by NixOS, this just sets sensible defaults.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homelab.services.vaultwarden;
in
{
  options.homelab.services.vaultwarden = {
    enable = mkEnableOption "Vaultwarden password manager with homelab defaults";

    domain = mkOption {
      type = types.str;
      default = "vault.homelab.local";
      description = "Domain name for Vaultwarden";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "HTTP port for Vaultwarden web interface";
    };

    rocketPort = mkOption {
      type = types.port;
      default = 8000;
      description = "Rocket port for Vaultwarden";
    };
  };

  config = mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;

      config = {
        DOMAIN = "http://${cfg.domain}:${toString cfg.port}";
        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_PORT = cfg.rocketPort;

        # Security settings
        SIGNUPS_ALLOWED = true;  # Set to false after creating your account
        INVITATIONS_ALLOWED = true;
        SHOW_PASSWORD_HINT = false;

        # Disable admin token requirement for initial setup
        # IMPORTANT: Set a strong admin token in production!
        # ADMIN_TOKEN = "your-secure-token-here";
      };
    };

    # Reverse proxy configuration (optional, but recommended)
    # You might want to set up nginx or caddy for HTTPS
    # For now, we'll just ensure the firewall is open
    networking.firewall.allowedTCPPorts = mkIf cfg.enable [
      cfg.port
      cfg.rocketPort
    ];

    # Backup reminder
    # IMPORTANT: Regularly backup /var/lib/bitwarden_rs/
    # This contains your encrypted password vault!
  };
}
