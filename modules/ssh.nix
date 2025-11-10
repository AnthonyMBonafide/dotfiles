{ config, pkgs, ... }:

{
  # SSH Client Configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Host-specific configurations
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };

      # Default wildcard match block for all other hosts
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };
    };
  };

  # SSH Agent Service
  # Runs as a systemd user service and automatically starts at login
  services.ssh-agent = {
    enable = true;
  };
}
