{ config, lib, pkgs, ... }:

{
  # YubiKey FIDO2 LUKS Disk Encryption Configuration
  #
  # This module enables YubiKey-based disk decryption using FIDO2.
  # IMPORTANT: This configuration is DECLARATIVE for the unlock process,
  # but YubiKey enrollment MUST be done manually (see below).
  #
  # MANUAL ENROLLMENT REQUIRED (One-time setup per machine):
  #
  # After deploying this configuration and rebooting, you must enroll your
  # YubiKey(s) manually using systemd-cryptenroll:
  #
  # 1. Insert your primary YubiKey
  # 2. Run: sudo systemd-cryptenroll --fido2-device=auto \
  #           --fido2-with-user-verification=true \
  #           --fido2-with-user-presence=false \
  #           /dev/disk/by-uuid/<your-luks-uuid>
  # 3. Enter your current LUKS password when prompted
  # 4. Enter your YubiKey PIN when prompted
  # 5. Repeat for additional YubiKeys (recommended: 2-3 for redundancy)
  #
  # To find your LUKS UUID, check your hardware-configuration.nix
  #
  # WHY MANUAL?
  # - FIDO2 security model requires physical presence (button press + PIN)
  # - Hardware generates unique credentials that cannot be pre-generated
  # - Every YubiKey is cryptographically unique
  # - See: https://nixos.wiki/wiki/Yubikey#LUKS_encrypted_FIDO2_unlock
  #
  # TESTING:
  # 1. Reboot and verify YubiKey + PIN unlocks the disk
  # 2. Test password fallback (remove YubiKey and boot)
  # 3. Verify all enrolled YubiKeys work
  #
  # RECOVERY:
  # - Password fallback is enabled (fallbackToPassword = true)
  # - Keep your LUKS password safe as backup
  # - Consider generating a recovery key:
  #   sudo systemd-cryptenroll --recovery-key /dev/disk/by-uuid/<uuid>
  #
  # For detailed instructions, see: docs/yubikey-luks-enrollment.md

  # Enable systemd in initrd (required for FIDO2 support)
  boot.initrd.systemd.enable = true;

  # Legacy FIDO2 support is not needed when using systemd
  # systemd-cryptenroll handles FIDO2 directly
  boot.initrd.luks.fido2Support = false;

  # Ensure YubiKey tools are available for enrollment
  environment.systemPackages = with pkgs; [
    yubikey-manager
    systemd  # Provides systemd-cryptenroll
  ];

  # Enable PC/SC daemon for smart card support (required for YubiKey)
  # This is likely already enabled by yubikey-auth.nix but included for completeness
  services.pcscd.enable = true;

  # Ensure udev rules for YubiKey are present
  # Also likely already configured, but ensuring it's explicit
  services.udev.packages = [ pkgs.yubikey-personalization ];
}
