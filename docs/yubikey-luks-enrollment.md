# YubiKey LUKS Disk Encryption Enrollment Guide

This guide walks you through enrolling YubiKey(s) for LUKS disk decryption using FIDO2 on your NixOS systems.

## Overview

Your NixOS systems have been configured to support YubiKey-based disk decryption. The configuration is **declarative** (the unlock behavior is defined in Nix), but YubiKey enrollment **must be done manually** (one-time setup per machine) due to FIDO2 security requirements.

### Why Manual Enrollment?

- **Security Model**: FIDO2 requires physical user presence (button press + PIN) during credential creation
- **Hardware Cryptography**: Each YubiKey generates unique credentials internally that cannot be pre-generated
- **Device Uniqueness**: Every YubiKey is cryptographically unique and must be enrolled individually

### What's Already Configured

✅ **Declarative (in your Nix configs)**:
- Systemd initrd enabled for FIDO2 support
- LUKS devices configured with `fido2-device=auto`
- Password fallback is automatic with systemd stage 1 (no explicit configuration needed)
- YubiKey tools and services installed

❌ **Manual (you need to do)**:
- Enroll each YubiKey to your LUKS device
- Test the enrollment works
- Verify fallback authentication

---

## Prerequisites

Before starting, ensure:

1. ✅ You've deployed the new configuration with `sudo nixos-rebuild switch`
2. ✅ You have your YubiKey(s) ready (2-3 recommended for redundancy)
3. ✅ You know your current LUKS password
4. ✅ You know your YubiKey PIN (set during YubiKey initial setup)
5. ✅ Your system is running LUKS2 (check with: `sudo cryptsetup luksDump /dev/disk/by-uuid/YOUR-UUID | grep Version`)

### Checking LUKS Version

```bash
# For black-mesa
sudo cryptsetup luksDump /dev/disk/by-uuid/29509493-cf8a-43ad-aafe-421a456ba58a | grep Version

# For nixos
sudo cryptsetup luksDump /dev/disk/by-uuid/f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8 | grep Version
```

**Expected output**: `Version:        2`

If you see `Version: 1`, you'll need to convert to LUKS2 first (see "Converting LUKS1 to LUKS2" below).

---

## Enrollment Steps

### Step 1: Verify YubiKey is Detected

```bash
# List connected YubiKeys
ykman list

# Expected output:
# YubiKey 5 NFC (5.x.x) [OTP+FIDO+CCID] Serial: 12345678
```

### Step 2: Check Current LUKS Key Slots

Before enrollment, see what slots are already used:

```bash
# For black-mesa
sudo cryptsetup luksDump /dev/disk/by-uuid/29509493-cf8a-43ad-aafe-421a456ba58a

# For nixos
sudo cryptsetup luksDump /dev/disk/by-uuid/f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8
```

Look for the "Keyslots" section. Your password is likely in slot 0 or 1.

### Step 3: Enroll Your Primary YubiKey

Insert your primary YubiKey and run:

**For black-mesa:**
```bash
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-user-verification=true \
  --fido2-with-user-presence=false \
  /dev/disk/by-uuid/29509493-cf8a-43ad-aafe-421a456ba58a
```

**For nixos:**
```bash
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-user-verification=true \
  --fido2-with-user-presence=false \
  /dev/disk/by-uuid/f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8
```

**What happens:**
1. You'll be prompted for your current LUKS password
2. You'll be prompted for your YubiKey PIN
3. The YubiKey LED may blink (don't touch it with these settings)
4. Enrollment completes and adds a FIDO2 token to a new LUKS slot

**Options explained:**
- `--fido2-device=auto`: Automatically detect connected FIDO2 device
- `--fido2-with-user-verification=true`: Require PIN (more secure)
- `--fido2-with-user-presence=false`: Don't require touch (faster boot, PIN is enough)

**Alternative (require touch instead of PIN):**
```bash
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-user-presence=true \
  --fido2-with-user-verification=false \
  /dev/disk/by-uuid/YOUR-UUID
```

### Step 4: Enroll Additional YubiKeys (Recommended)

**Important**: Enroll 2-3 YubiKeys for redundancy in case one is lost or damaged.

Remove your first YubiKey, insert the second one, and repeat Step 3:

**For black-mesa:**
```bash
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-user-verification=true \
  --fido2-with-user-presence=false \
  /dev/disk/by-uuid/29509493-cf8a-43ad-aafe-421a456ba58a
```

**For nixos:**
```bash
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-user-verification=true \
  --fido2-with-user-presence=false \
  /dev/disk/by-uuid/f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8
```

Repeat for your third YubiKey if desired.

### Step 5: Verify Enrollment

Check that FIDO2 tokens were added:

```bash
# For black-mesa
sudo cryptsetup luksDump /dev/disk/by-uuid/29509493-cf8a-43ad-aafe-421a456ba58a

# For nixos
sudo cryptsetup luksDump /dev/disk/by-uuid/f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8
```

Look for the "Tokens" section. You should see entries like:
```
Tokens:
  0: systemd-fido2
        fido2-credential: ...
        fido2-rp: io.systemd.cryptsetup
  1: systemd-fido2
        fido2-credential: ...
        fido2-rp: io.systemd.cryptsetup
```

Each enrolled YubiKey gets its own token.

---

## Testing

### Test 1: Reboot with YubiKey Present

1. Insert your YubiKey
2. Reboot the system: `sudo reboot`
3. At boot, the system should:
   - Detect your YubiKey automatically
   - Prompt for your YubiKey PIN
   - Unlock the disk without asking for LUKS password

**Expected flow:**
```
Please enter FIDO2 token PIN: [enter your YubiKey PIN]
[System boots normally]
```

### Test 2: Verify Password Fallback

1. Remove all YubiKeys from the system
2. Reboot: `sudo reboot`
3. At boot, the system should:
   - Wait 10 seconds for a FIDO2 token (timeout configured in `token-timeout=10`)
   - Fall back to password prompt
   - Accept your LUKS password

**Expected flow:**
```
[10 second wait]
Please enter passphrase for disk /dev/disk/by-uuid/...: [enter LUKS password]
[System boots normally]
```

### Test 3: Test All Enrolled YubiKeys

For each enrolled YubiKey:
1. Remove all other YubiKeys
2. Insert the one you want to test
3. Reboot
4. Verify it unlocks successfully with its PIN

---

## Recovery & Troubleshooting

### I Lost My YubiKey

**Don't panic!** You have fallback options:

1. **Use another enrolled YubiKey** (if you enrolled multiple)
2. **Use your LUKS password** (always kept as fallback)
3. **Use a recovery key** (if you generated one - see below)

### Generate a Recovery Key (Optional but Recommended)

A recovery key is a long random passphrase that can unlock your disk:

**For black-mesa:**
```bash
sudo systemd-cryptenroll --recovery-key \
  /dev/disk/by-uuid/29509493-cf8a-43ad-aafe-421a456ba58a
```

**For nixos:**
```bash
sudo systemd-cryptenroll --recovery-key \
  /dev/disk/by-uuid/f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8
```

**Important**:
- Write down the recovery key on paper
- Store it in a secure location (safe, safety deposit box, etc.)
- This is a one-time display - you cannot retrieve it later

### Remove an Enrolled YubiKey

If you lose a YubiKey and want to remove its credential:

First, list all tokens:
```bash
sudo cryptsetup luksDump /dev/disk/by-uuid/YOUR-UUID
```

Then wipe a specific token (0, 1, 2, etc.):
```bash
sudo systemd-cryptenroll --wipe-slot=fido2 /dev/disk/by-uuid/YOUR-UUID
```

Or wipe all FIDO2 tokens:
```bash
sudo systemd-cryptenroll --wipe-slot=fido2 /dev/disk/by-uuid/YOUR-UUID --fido2-device=auto
```

### Boot Asks for PIN Twice

This is a known issue in some configurations. If you experience this:

1. Check that `boot.initrd.systemd.enable = true` is set
2. Ensure `boot.initrd.luks.fido2Support = false` (systemd handles it)
3. Try removing and re-enrolling the YubiKey

### System Won't Boot After Enrollment

**Recovery steps:**

1. At the boot prompt, wait 10 seconds
2. Enter your LUKS password when prompted
3. Once booted, check system logs:
   ```bash
   sudo journalctl -b | grep cryptsetup
   sudo journalctl -b | grep systemd-cryptenroll
   ```
4. Verify your hardware-configuration.nix has the correct settings
5. Re-run `sudo nixos-rebuild switch` and try again

### Converting LUKS1 to LUKS2

If you have LUKS1, you must convert to LUKS2 for FIDO2 support:

**⚠️ WARNING**: This is a one-way conversion. Back up your data first!

```bash
# BACKUP YOUR DATA FIRST!

# Convert to LUKS2
sudo cryptsetup convert --type luks2 /dev/disk/by-uuid/YOUR-UUID

# Verify conversion
sudo cryptsetup luksDump /dev/disk/by-uuid/YOUR-UUID | grep Version
```

---

## System-Specific Information

### black-mesa (AMD Desktop)

- **LUKS Device**: `luks-29509493-cf8a-43ad-aafe-421a456ba58a`
- **UUID**: `29509493-cf8a-43ad-aafe-421a456ba58a`
- **Config**: `/home/anthony/dotfiles/hosts/black-mesa/hardware-configuration.nix`

**Enrollment command:**
```bash
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-user-verification=true \
  --fido2-with-user-presence=false \
  /dev/disk/by-uuid/29509493-cf8a-43ad-aafe-421a456ba58a
```

### nixos (Intel Laptop)

- **LUKS Device**: `luks-f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8`
- **UUID**: `f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8`
- **Config**: `/home/anthony/dotfiles/hosts/nixos/hardware-configuration.nix`

**Enrollment command:**
```bash
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-user-verification=true \
  --fido2-with-user-presence=false \
  /dev/disk/by-uuid/f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8
```

---

## Quick Reference

### List Enrolled Tokens
```bash
sudo cryptsetup luksDump /dev/disk/by-uuid/YOUR-UUID
```

### Enroll New YubiKey
```bash
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-user-verification=true \
  /dev/disk/by-uuid/YOUR-UUID
```

### Remove FIDO2 Token
```bash
sudo systemd-cryptenroll --wipe-slot=fido2 /dev/disk/by-uuid/YOUR-UUID
```

### Generate Recovery Key
```bash
sudo systemd-cryptenroll --recovery-key /dev/disk/by-uuid/YOUR-UUID
```

### View Boot Logs
```bash
sudo journalctl -b | grep -i crypt
```

---

## Security Best Practices

1. ✅ **Enroll multiple YubiKeys** (2-3) for redundancy
2. ✅ **Keep your LUKS password** as fallback (don't remove it)
3. ✅ **Generate and store a recovery key** in a secure physical location
4. ✅ **Use PIN verification** (`--fido2-with-user-verification=true`) for security
5. ✅ **Test all enrolled keys** after enrollment
6. ✅ **Document which YubiKeys are enrolled** on each system
7. ❌ **Don't share YubiKeys** between users
8. ❌ **Don't remove password slots** unless you have multiple fallbacks

---

## Additional Resources

- [NixOS Wiki: YubiKey LUKS](https://nixos.wiki/wiki/Yubikey#LUKS_encrypted_FIDO2_unlock)
- [systemd-cryptenroll man page](https://www.freedesktop.org/software/systemd/man/systemd-cryptenroll.html)
- [FIDO2 Specification](https://fidoalliance.org/fido2/)
- [YubiKey Manager Documentation](https://developers.yubico.com/yubikey-manager/)

---

## Support

If you encounter issues:

1. Check system logs: `sudo journalctl -b | grep -i crypt`
2. Verify configuration files haven't been modified
3. Test with password fallback to ensure disk is accessible
4. Consult the NixOS Discourse or YubiKey forums for community support

---

**Last Updated**: 2025-11-27
**Configuration Version**: YubiKey FIDO2 with systemd-cryptenroll
