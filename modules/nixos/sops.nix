{ config, pkgs, lib, ... }:

{
  # Install SOPS and age tools system-wide
  environment.systemPackages = with pkgs; [
    sops
    age
    age-plugin-yubikey
  ];

  # Configure sops-nix
  sops = {
    # Default SOPS file format
    defaultSopsFormat = "yaml";

    # Validate SOPS files at evaluation time
    # Set to false initially since secrets don't exist yet
    # Change to true after running: ./scripts/manage-yubikey-secrets.sh init
    validateSopsFiles = false;

    # Age key configuration for YubiKey PIV
    age = {
      # Path to age keys file (will be generated)
      keyFile = "/var/lib/sops-nix/key.txt";

      # Generate age key if it doesn't exist
      generateKey = true;

      # SSH host keys can also be used as age keys (fallback)
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    # Define secrets for SSH keys
    secrets = {
      # Personal SSH key (shared across hosts)
      "id_ed25519" = {
        owner = config.users.users.anthony.name;
        group = config.users.users.anthony.group;
        mode = "0600";
        path = "/home/anthony/.ssh/id_ed25519";
        sopsFile = ../../secrets/ssh/id_ed25519.yaml;
        key = "data";
      };

      # Host-specific SSH key for nixos laptop
      "nixos_ed25519" = lib.mkIf (config.networking.hostName == "nixos") {
        owner = config.users.users.anthony.name;
        group = config.users.users.anthony.group;
        mode = "0600";
        path = "/home/anthony/.ssh/nixos_ed25519";
        sopsFile = ../../secrets/ssh/nixos_ed25519.yaml;
        key = "data";
      };

      # Host-specific SSH key for black-mesa desktop
      "black-mesa_ed25519" = lib.mkIf (config.networking.hostName == "black-mesa") {
        owner = config.users.users.anthony.name;
        group = config.users.users.anthony.group;
        mode = "0600";
        path = "/home/anthony/.ssh/black-mesa_ed25519";
        sopsFile = ../../secrets/ssh/black-mesa_ed25519.yaml;
        key = "data";
      };
    };
  };

  # Ensure secrets directory exists with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/sops-nix 0755 root root -"
  ];

  # Note: YubiKey PIV must be available during system activation
  # for secrets decryption. The age-plugin-yubikey will prompt for PIN.
}
