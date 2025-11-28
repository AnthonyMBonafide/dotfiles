{ config, pkgs, lib, ... }:

{
  # Install pam_u2f for Yubikey authentication
  environment.systemPackages = with pkgs; [
    pam_u2f
  ];

  # Configure PAM services to allow Yubikey authentication as an alternative to password
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

    # Use "sufficient" auth mode so either password OR Yubikey works
    # This means: try Yubikey first, if it succeeds you're in
    # If Yubikey fails or is not present, fall back to password
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

      # Origin for U2F (optional, can be set if needed)
      # origin = "pam://hostname";

      # AppId for U2F (optional)
      # appid = "pam://hostname";
    };
  };
}
