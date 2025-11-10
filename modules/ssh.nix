{ config, pkgs, ... }:

{
  # SSH Client Configuration
  programs.ssh = {
    enable = true;

    # Automatically add keys to ssh-agent
    addKeysToAgent = "yes";

    # Only use authentication identities configured in ssh config
    extraConfig = ''
      IdentitiesOnly yes
    '';

    # Host-specific configurations
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };

  # SSH Agent Service
  # Runs as a systemd user service and automatically starts at login
  services.ssh-agent = {
    enable = true;
  };
}
