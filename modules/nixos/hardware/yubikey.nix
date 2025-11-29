{ config, pkgs, lib, ... }:

{
  options = {
    # Option to enable YubiKey authentication
    yubikey.auth.enable = lib.mkEnableOption "YubiKey U2F/FIDO2 authentication";

    # Option to enable YubiKey disk encryption
    yubikey.encryption.enable = lib.mkEnableOption "YubiKey disk encryption support";
  };

  config = lib.mkMerge [
    # Base YubiKey support (always enabled if this module is imported)
    {
      # YubiKey and FIDO2/U2F support
      services.pcscd.enable = true;  # PC/SC Smart Card Daemon for FIDO2 support
      services.udev.packages = [
        pkgs.yubikey-personalization  # YubiKey udev rules
        pkgs.libu2f-host  # U2F host library with udev rules
      ];

      # Add additional udev rules for YubiKey access
      services.udev.extraRules = ''
        # YubiKey FIDO/U2F support
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", MODE="0660", GROUP="plugdev", TAG+="uaccess"
      '';

      # YubiKey tools
      environment.systemPackages = with pkgs; [
        yubikey-manager  # CLI and GUI tool for configuring YubiKeys
        yubioath-flutter  # GUI for YubiKey OATH (authenticator) management
        yubico-piv-tool  # YubiKey PIV (smart card) tool
      ];
    }

    # YubiKey authentication configuration
    (lib.mkIf config.yubikey.auth.enable {
      # Install pam_u2f for YubiKey authentication
      environment.systemPackages = with pkgs; [
        pam_u2f
      ];

      # Configure PAM services to allow YubiKey authentication as an alternative to password
      security.pam.services = {
        # System login via GDM
        gdm.u2fAuth = true;

        # Sudo authentication
        sudo.u2fAuth = true;

        # SSH server authentication (if enabled in the future)
        sshd.u2fAuth = true;
      };

      # PAM U2F configuration
      security.pam.u2f = {
        enable = true;

        # Use "sufficient" auth mode so either password OR YubiKey works
        # This means: try YubiKey first, if it succeeds you're in
        # If YubiKey fails or is not present, fall back to password
        control = "sufficient";

        # Settings for pam_u2f
        settings = {
          # Location of the u2f_keys file (managed by Home Manager)
          # Using %u for username substitution
          authfile = "/home/%u/.config/Yubico/u2f_keys";

          # Enable variable expansion (%u, %h, etc.)
          expand = true;

          # Enable debug logging (disabled after successful testing)
          debug = false;

          # Interactive mode - prompt for touch
          cue = true;
        };
      };
    })

    # YubiKey disk encryption configuration
    (lib.mkIf config.yubikey.encryption.enable {
      # Boot configuration for YubiKey LUKS unlock
      boot.initrd = {
        # Enable systemd in initrd for better YubiKey support
        systemd.enable = true;
      };

      # Note: LUKS device configuration must be done in host-specific configuration
      # because the device path is unique to each system.
      # Example configuration for hosts:
      #
      # boot.initrd.luks.devices."luks-root" = {
      #   device = "/dev/disk/by-uuid/YOUR-UUID-HERE";
      #   fido2 = {
      #     credential = "...";  # FIDO2 credential from systemd-cryptenroll
      #   };
      # };
    })
  ];
}
