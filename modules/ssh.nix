{ config, pkgs, ... }:

{
  # SSH Client Configuration
  # Note: SSH keys are managed by SOPS (see modules/nixos/sops.nix)
  # Keys are decrypted from secrets/ssh/*.yaml and deployed to ~/.ssh/
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Host-specific configurations
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        # Personal SSH key (deployed by SOPS from secrets/ssh/id_ed25519.yaml)
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };

      # Default wildcard match block for all other hosts
      "*" = {
        # Personal SSH key used for general SSH access
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
