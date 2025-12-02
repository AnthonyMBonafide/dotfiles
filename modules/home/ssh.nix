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
        identityFile = [ "~/.ssh/id_ed25519_sk" "~/.ssh/id_ed25519" ];
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };

      # Default wildcard match block for all other hosts
      "*" = {
        identityFile = [ "~/.ssh/id_ed25519_sk" "~/.ssh/id_ed25519" ];
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

  # Disable GNOME Keyring SSH agent (doesn't support FIDO2 properly)
  # This allows the native OpenSSH agent to handle YubiKey FIDO2 keys
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
    # Force SSH to use askpass for YubiKey operations
    # This ensures a GUI prompt appears for YubiKey touch confirmation
    # Fixes "agent refused operation" errors during git commit signing
    SSH_ASKPASS_REQUIRE = "force";
  };

  # Mask GCR SSH agent services to prevent them from interfering
  # GCR's SSH agent doesn't properly support FIDO2/YubiKey signing
  systemd.user.services.gcr-ssh-agent = {
    Install.WantedBy = pkgs.lib.mkForce [ ];
  };

  systemd.user.sockets.gcr-ssh-agent = {
    Install.WantedBy = pkgs.lib.mkForce [ ];
  };

  # Ensure GNOME Keyring doesn't start its SSH component
  xdg.configFile."autostart/gnome-keyring-ssh.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=SSH Key Agent
      Exec=/bin/true
      X-GNOME-Autostart-enabled=false
      Hidden=true
    '';
  };
}
