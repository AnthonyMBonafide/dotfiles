# YubiKey SOPS Secrets Management

Complete guide to managing SSH keys and other secrets using SOPS with YubiKey age encryption.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Initial Setup](#initial-setup)
- [Daily Usage](#daily-usage)
- [Managing YubiKeys](#managing-yubikeys)
- [Rotating SSH Keys](#rotating-ssh-keys)
- [Backup and Recovery](#backup-and-recovery)
- [Troubleshooting](#troubleshooting)
- [Security Best Practices](#security-best-practices)

---

## Overview

This system provides secure, encrypted storage of SSH keys (and other secrets) in your Nix dotfiles repository. Secrets are encrypted using SOPS (Secrets OPerationS) with age encryption, where the age keys are stored on YubiKeys using PIV (Personal Identity Verification).

### Key Features

- **YubiKey Protection**: Age encryption keys stored on YubiKey PIV slots
- **Multiple YubiKeys**: Any of your 3 YubiKeys can decrypt secrets
- **Backup Key**: Password-protected backup age key for disaster recovery
- **Git-Safe**: Encrypted secrets can be safely committed to git
- **Automatic Deployment**: SOPS-nix automatically deploys decrypted keys during system activation
- **Host-Specific Keys**: Separate SSH keys for each host (nixos, black-mesa)
- **Personal Key**: Shared personal SSH key for GitHub and general use

### How It Works

1. Age encryption keys are generated and stored on YubiKey PIV slot 9a
2. SSH private keys are encrypted with SOPS using these age keys
3. Encrypted secrets are stored in `secrets/ssh/*.yaml` in git
4. During `nixos-rebuild`, SOPS-nix decrypts secrets using your YubiKey
5. Decrypted SSH keys are deployed to `~/.ssh/` with proper permissions
6. YubiKey PIN required during system activation for decryption

---

## Architecture

### Directory Structure

```
dotfiles/
├── .sops.yaml                      # SOPS configuration (age keys, rules)
├── secrets/
│   ├── ssh/
│   │   ├── id_ed25519.yaml        # Personal SSH key (encrypted)
│   │   ├── nixos_ed25519.yaml     # Laptop host key (encrypted)
│   │   └── black-mesa_ed25519.yaml # Desktop host key (encrypted)
│   ├── backup-key.age.enc         # Backup age key (password-protected)
│   └── backups/                   # Automatic backups during re-keying
├── modules/nixos/
│   └── sops.nix                   # SOPS-nix configuration
├── modules/
│   └── ssh.nix                    # SSH client configuration
└── scripts/
    ├── manage-yubikey-secrets.sh  # Main management script
    ├── test-yubikey-decrypt.sh    # Test YubiKey decryption
    └── rekey-secrets.sh           # Re-encrypt secrets after key changes
```

### Components

1. **SOPS**: Encrypts/decrypts secrets with age keys
2. **age-plugin-yubikey**: Integrates age encryption with YubiKey PIV
3. **sops-nix**: NixOS module that deploys decrypted secrets
4. **YubiKey PIV**: Stores age keys securely with PIN protection
5. **Backup Age Key**: Emergency recovery key (password-protected)

### Encryption Flow

```
YubiKey PIV Slot 9a → Age Private Key → SOPS Decryption → SSH Private Key → ~/.ssh/
                ↓
           Requires PIN
```

---

## Initial Setup

### Prerequisites

1. Three YubiKeys (already configured for LUKS and U2F auth)
2. YubiKey PINs (default: 123456, should be changed)
3. Password manager for storing backup key password
4. System updated with latest flake changes

### Step 1: Run Initial Setup

The management script includes an interactive setup wizard:

```bash
cd ~/dotfiles
./scripts/manage-yubikey-secrets.sh init
```

This wizard will:

1. Generate age keys on each of your 3 YubiKeys
2. Create a password-protected backup age key
3. Update `.sops.yaml` with all public age keys
4. Generate SSH keys (personal + host-specific)
5. Encrypt SSH keys with SOPS

### Step 2: What Happens During Setup

**For Each YubiKey:**
- Insert YubiKey when prompted
- Script generates age key in PIV slot 9a
- Age public key is extracted and displayed
- Repeat for all 3 YubiKeys

**Backup Key Generation:**
- Creates new age key pair
- Encrypts private key with password you provide
- Saves encrypted key to `secrets/backup-key.age.enc`
- **IMPORTANT**: Store this password in your password manager!

**SSH Key Generation:**
- Personal key: `id_ed25519` (for GitHub, general use)
- Host keys: `nixos_ed25519`, `black-mesa_ed25519`
- All keys encrypted with SOPS

### Step 3: Update Flake Lock

After initial setup, update your flake lock to fetch sops-nix:

```bash
cd ~/dotfiles
nix flake update
```

### Step 4: Test Decryption

Before rebuilding your system, verify a YubiKey can decrypt:

```bash
./scripts/test-yubikey-decrypt.sh
```

Expected output:
```
✓ YubiKey detected
ℹ Found 3 encrypted secret(s)
ℹ Testing: id_ed25519.yaml
  ✓ Decryption successful
...
```

### Step 5: Rebuild System

Now rebuild your NixOS system to deploy the secrets:

```bash
# For nixos laptop
sudo nixos-rebuild switch --flake .#nixos

# For black-mesa desktop
sudo nixos-rebuild switch --flake .#black-mesa
```

During rebuild, you'll be prompted for your YubiKey PIN to decrypt secrets.

### Step 6: Verify SSH Keys Deployed

After rebuild, check that SSH keys are in place:

```bash
ls -la ~/.ssh/

# Should show:
# -rw------- 1 anthony anthony ... id_ed25519
# -rw------- 1 anthony anthony ... nixos_ed25519  (or black-mesa_ed25519)
```

### Step 7: Commit Changes

Once everything works, commit the encrypted secrets:

```bash
git add .sops.yaml secrets/ modules/nixos/sops.nix
git add flake.nix flake.lock .gitignore
git add scripts/ docs/
git commit -m "feat: Add YubiKey SOPS secrets management"
```

**Note**: Only encrypted files are committed. Unencrypted secrets are git-ignored.

---

## Daily Usage

### System Rebuild

When you rebuild your system, SOPS will automatically decrypt secrets:

```bash
sudo nixos-rebuild switch --flake .
```

You'll be prompted for your YubiKey PIN once during activation.

### Adding New Secrets

To add a new secret (example: GitHub token):

```bash
cd ~/dotfiles

# Create new secret directory
mkdir -p secrets/github

# Create and encrypt secret
echo "ghp_your_token_here" | sops -e /dev/stdin > secrets/github/token.yaml

# Test decryption
sops -d secrets/github/token.yaml
```

Then add the secret to `modules/nixos/sops.nix`:

```nix
sops.secrets."github/token" = {
  owner = config.users.users.anthony.name;
  mode = "0600";
  path = "/home/anthony/.config/github/token";
};
```

### Using a Different YubiKey

Simply insert a different YubiKey before rebuilding. Any of your enrolled YubiKeys will work.

---

## Managing YubiKeys

### Adding a New YubiKey

1. Run enrollment wizard:

```bash
./scripts/manage-yubikey-secrets.sh enroll
# Select option 1: Add new YubiKey
```

2. Insert new YubiKey and wait for age key generation

3. Copy the displayed age public key

4. Manually add to `.sops.yaml`:

```yaml
keys:
  # ... existing keys ...
  - &yubikey4 age1abc123xyz...  # YubiKey 4
```

5. Add new key to `creation_rules` age list:

```yaml
creation_rules:
  - path_regex: secrets/ssh/.*
    age: >-
      age1key1,
      age1key2,
      age1key3,
      age1abc123xyz,  # <-- New YubiKey
      age1backup
```

6. Re-encrypt all secrets with new key:

```bash
./scripts/rekey-secrets.sh
```

7. Test with new YubiKey:

```bash
./scripts/test-yubikey-decrypt.sh
```

8. Commit changes:

```bash
git add .sops.yaml secrets/
git commit -m "feat: Add YubiKey 4 to SOPS"
```

### Removing a YubiKey

**Warning**: Only remove a YubiKey if it's lost/damaged or you want to revoke its access.

1. Remove YubiKey public key from `.sops.yaml` (both `keys` section and `creation_rules`)

2. Re-encrypt all secrets without the removed key:

```bash
./scripts/rekey-secrets.sh
```

3. The removed YubiKey can no longer decrypt secrets

4. Commit changes:

```bash
git add .sops.yaml secrets/
git commit -m "feat: Remove YubiKey 2 from SOPS"
```

### Listing Enrolled YubiKeys

View all enrolled YubiKeys:

```bash
./scripts/manage-yubikey-secrets.sh enroll
# Select option 3: List enrolled YubiKeys
```

Or manually check `.sops.yaml`:

```bash
grep "age1" .sops.yaml | grep -v "^#"
```

---

## Rotating SSH Keys

If your SSH keys are compromised or you want to rotate them for security:

### Automatic Rotation

```bash
./scripts/manage-yubikey-secrets.sh rotate
```

This will:
1. Backup existing encrypted keys to `secrets/backups/YYYYMMDD_HHMMSS/`
2. Generate new SSH key pairs
3. Encrypt new keys with SOPS
4. Clean up temporary files

### Manual Rotation

```bash
cd ~/dotfiles/secrets/ssh

# Generate new key
ssh-keygen -t ed25519 -f ./new_id_ed25519 -C "anthony@personal"

# Encrypt with SOPS
sops -e ./new_id_ed25519 > id_ed25519.yaml

# Clean up
shred -u ./new_id_ed25519 ./new_id_ed25519.pub
```

### After Rotation

1. Rebuild system to deploy new keys:

```bash
sudo nixos-rebuild switch --flake .
```

2. Update public keys on remote services:

```bash
# Display new public key
ssh-keygen -y -f ~/.ssh/id_ed25519

# Add to GitHub: https://github.com/settings/keys
# Add to other servers: ssh-copy-id user@server
```

3. Commit encrypted new keys:

```bash
git add secrets/ssh/
git commit -m "feat: Rotate SSH keys"
```

---

## Backup and Recovery

### Disaster Recovery Scenarios

#### Scenario 1: Lost Access to All YubiKeys

If you lose all YubiKeys, use the backup age key:

```bash
cd ~/dotfiles

# Decrypt backup key with password
age -d secrets/backup-key.age.enc > /tmp/backup-key.age

# Decrypt a secret using backup key
SOPS_AGE_KEY_FILE=/tmp/backup-key.age sops -d secrets/ssh/id_ed25519.yaml > ~/.ssh/id_ed25519

# Clean up
shred -u /tmp/backup-key.age
```

#### Scenario 2: Forgot Backup Key Password

If you forgot the backup key password but still have YubiKeys:

1. Generate a new backup age key:

```bash
age-keygen -o secrets/backup-key.age
```

2. Encrypt it with new password:

```bash
age -p -o secrets/backup-key.age.enc secrets/backup-key.age
shred -u secrets/backup-key.age
```

3. Update `.sops.yaml` with new backup public key

4. Re-encrypt all secrets:

```bash
./scripts/rekey-secrets.sh
```

#### Scenario 3: Complete System Rebuild

To rebuild your system from scratch with just one YubiKey:

1. Clone dotfiles:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Insert YubiKey (any enrolled YubiKey)

3. Test decryption:

```bash
nix-shell -p age age-plugin-yubikey sops
./scripts/test-yubikey-decrypt.sh
```

4. Rebuild system:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

Your SSH keys and secrets are automatically deployed!

### Testing Backup Key

Regularly test your backup key to ensure it works:

```bash
./scripts/manage-yubikey-secrets.sh backup
# Select option 1: Test decrypt with backup key
```

### Creating Manual Backups

Export all secrets for offline backup:

```bash
./scripts/manage-yubikey-secrets.sh backup
# Select option 2: Export secrets

# Secrets exported to /tmp/sops-secrets-export-TIMESTAMP/
# Copy to secure USB drive or encrypted backup
```

**Important**: Delete exported secrets after backing up:

```bash
shred -u /tmp/sops-secrets-export-*/
rmdir /tmp/sops-secrets-export-*
```

### Storing Backup Key Password

**Critical**: Store your backup key password in multiple secure locations:

1. Password manager (1Password, Bitwarden, etc.)
2. Physical paper in a safe
3. Encrypted USB drive in secure location

Example password manager entry:
```
Title: NixOS SOPS Backup Age Key
Username: anthony@dotfiles
Password: [your strong password]
Notes: Decrypts ~/dotfiles/secrets/backup-key.age.enc
       Used for disaster recovery if all YubiKeys are lost
```

---

## Troubleshooting

### "No YubiKey detected"

**Problem**: `age-plugin-yubikey --list` shows no YubiKeys

**Solutions**:
1. Check YubiKey is inserted:
   ```bash
   lsusb | grep Yubico
   ```

2. Verify pcscd is running:
   ```bash
   systemctl status pcscd
   ```

3. Check udev rules:
   ```bash
   ls -la /etc/udev/rules.d/ | grep yubikey
   ```

4. Re-insert YubiKey and try again

### "Failed to decrypt secret"

**Problem**: SOPS can't decrypt secrets during rebuild

**Solutions**:

1. Verify YubiKey is enrolled:
   ```bash
   ./scripts/test-yubikey-decrypt.sh
   ```

2. Check YubiKey PIN is correct (try unlocking):
   ```bash
   age-plugin-yubikey --list
   ```

3. Verify .sops.yaml has correct age key:
   ```bash
   age-plugin-yubikey --identity | grep "age1"
   # Compare with .sops.yaml keys
   ```

4. Check secret file has correct SOPS metadata:
   ```bash
   cat secrets/ssh/id_ed25519.yaml | grep "sops:"
   ```

### "Permission denied" after system rebuild

**Problem**: SSH keys deployed but have wrong permissions

**Solutions**:

1. Check file ownership:
   ```bash
   ls -la ~/.ssh/id_ed25519
   # Should be: -rw------- anthony anthony
   ```

2. Manually fix permissions:
   ```bash
   chmod 600 ~/.ssh/id_ed25519
   chown anthony:anthony ~/.ssh/id_ed25519
   ```

3. Check SOPS module configuration in `modules/nixos/sops.nix`:
   ```nix
   "ssh/id_ed25519" = {
     owner = "anthony";
     group = "anthony";
     mode = "0600";
     # ...
   };
   ```

### "Age key generation failed"

**Problem**: Can't generate age key on YubiKey PIV

**Solutions**:

1. Check PIV applet is enabled:
   ```bash
   ykman info
   # Should show "PIV" in enabled applications
   ```

2. Reset PIV if needed (⚠️ WARNING: Destroys existing PIV keys):
   ```bash
   ykman piv reset
   ```

3. Verify slot 9a is available:
   ```bash
   yubico-piv-tool -a status
   ```

### "System rebuild hangs during activation"

**Problem**: Rebuild appears frozen during secrets activation

**Cause**: Waiting for YubiKey PIN input (might not be visible)

**Solution**: Check for PIN prompt in terminal, enter PIN

### Secrets not deployed after rebuild

**Problem**: SSH keys missing from ~/.ssh/ after rebuild

**Solutions**:

1. Check SOPS module is imported:
   ```bash
   grep "sops.nix" hosts/*/configuration.nix
   ```

2. Verify sops-nix is in flake inputs:
   ```bash
   grep "sops-nix" flake.nix
   ```

3. Check secret paths in SOPS module match actual files:
   ```bash
   ls -la secrets/ssh/
   cat modules/nixos/sops.nix | grep "secrets\."
   ```

4. Review system activation logs:
   ```bash
   journalctl -b -u sops-nix
   ```

---

## Security Best Practices

### YubiKey Security

1. **Change Default PIN**: YubiKey PIV default PIN is `123456`
   ```bash
   ykman piv access change-pin
   ```

2. **Enable Touch Requirement**: Require touch for PIV operations (optional)
   ```bash
   ykman piv set-touch-policy 9a always
   ```

3. **Store Safely**: Keep YubiKeys in different physical locations

4. **Test Regularly**: Verify each YubiKey can decrypt monthly

### Backup Key Security

1. **Strong Password**: Use 20+ character passphrase from password manager

2. **Multiple Backups**: Store password in 3+ secure locations

3. **Test Recovery**: Test backup key decryption every 6 months

4. **Encrypted Storage**: Keep `backup-key.age.enc` encrypted in git only

### Secrets Management

1. **Rotate Keys**: Rotate SSH keys annually or after compromise

2. **Audit Access**: Review `.sops.yaml` enrolled keys quarterly

3. **Least Privilege**: Only add necessary secrets to SOPS

4. **Monitor Changes**: Review git diff before committing secrets

### Git Safety

1. **Never Commit Unencrypted**: .gitignore prevents accidental commits

2. **Verify Encryption**: Check files are SOPS-encrypted:
   ```bash
   head -20 secrets/ssh/id_ed25519.yaml
   # Should show: sops: ...
   ```

3. **Review Before Push**:
   ```bash
   git diff --cached secrets/
   ```

4. **Signed Commits**: Use GPG/SSH signing for secrets commits

### System Hardening

1. **Encrypt Disk**: Use LUKS with YubiKey (already configured)

2. **Full Disk Encryption**: All sensitive data on encrypted partition

3. **Secure Boot**: Consider enabling secure boot (optional)

4. **FirewallSSH**: Only enable SSH server if needed

### Emergency Procedures

**If YubiKey is compromised:**

1. Remove compromised YubiKey from `.sops.yaml`
2. Run `./scripts/rekey-secrets.sh`
3. Rotate all SSH keys
4. Update public keys on all services
5. Review system logs for unauthorized access

**If backup key password is exposed:**

1. Generate new backup key with new password
2. Update `.sops.yaml` with new backup public key
3. Re-encrypt all secrets
4. Delete old encrypted backup key

**If secrets repository is compromised:**

1. Assume all secrets are compromised
2. Rotate all SSH keys immediately
3. Generate new age keys on all YubiKeys
4. Create new backup key
5. Re-encrypt all secrets with new keys
6. Force push to git to rewrite history (⚠️ dangerous)

---

## Advanced Usage

### Per-Host Secrets

To create host-specific secrets (only readable on one host):

1. Generate age key from SSH host key:

```bash
nix-shell -p ssh-to-age
cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
# Output: age1host_specific_key...
```

2. Add to `.sops.yaml`:

```yaml
creation_rules:
  - path_regex: secrets/nixos-only/.*
    age: >-
      age1yubikey1,
      age1host_specific_key  # Only nixos can decrypt
```

3. Encrypt secret:

```bash
echo "sensitive-data" | sops -e /dev/stdin > secrets/nixos-only/secret.yaml
```

### Multiple Secret Types

Organize different types of secrets:

```
secrets/
├── ssh/          # SSH keys
├── github/       # GitHub tokens
├── aws/          # AWS credentials
├── wireguard/    # VPN keys
└── certificates/ # SSL/TLS certs
```

Each can have different age key access in `.sops.yaml`.

### Integration with Home Manager

To use SOPS secrets in home-manager:

```nix
# In home.nix
home.file.".config/github/token".source = config.sops.secrets."github/token".path;
```

### Automated Secret Rotation

Create a systemd timer for regular key rotation (advanced):

```nix
systemd.timers.rotate-ssh-keys = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = "monthly";
    Persistent = true;
  };
};

systemd.services.rotate-ssh-keys = {
  serviceConfig.Type = "oneshot";
  script = ''
    ${pkgs.bash}/bin/bash /home/anthony/dotfiles/scripts/manage-yubikey-secrets.sh rotate
  '';
};
```

---

## Additional Resources

- [SOPS Documentation](https://github.com/mozilla/sops)
- [sops-nix Documentation](https://github.com/Mic92/sops-nix)
- [age-plugin-yubikey](https://github.com/str4d/age-plugin-yubikey)
- [YubiKey PIV Guide](https://developers.yubico.com/PIV/)
- [Age Encryption Specification](https://age-encryption.org/)

---

## Quick Reference

### Common Commands

```bash
# Initial setup
./scripts/manage-yubikey-secrets.sh init

# Test YubiKey decryption
./scripts/test-yubikey-decrypt.sh

# Add new YubiKey
./scripts/manage-yubikey-secrets.sh enroll

# Re-encrypt after key changes
./scripts/rekey-secrets.sh

# Rotate SSH keys
./scripts/manage-yubikey-secrets.sh rotate

# Test backup key
./scripts/manage-yubikey-secrets.sh backup

# Rebuild system with secrets
sudo nixos-rebuild switch --flake .

# Manually decrypt a secret
sops -d secrets/ssh/id_ed25519.yaml

# Manually encrypt a secret
sops -e /path/to/file > secrets/file.yaml

# List YubiKey age identities
age-plugin-yubikey --list

# Check SOPS file metadata
sops secrets/ssh/id_ed25519.yaml
```

### File Locations

```
~/dotfiles/.sops.yaml                    # SOPS configuration
~/dotfiles/secrets/ssh/                  # Encrypted SSH keys
~/dotfiles/secrets/backup-key.age.enc    # Backup age key
~/dotfiles/modules/nixos/sops.nix        # SOPS-nix module
~/.ssh/id_ed25519                        # Deployed personal SSH key
~/.ssh/nixos_ed25519                     # Deployed host key (if on nixos)
~/.ssh/black-mesa_ed25519                # Deployed host key (if on black-mesa)
```

---

**Last Updated**: 2025-11-28
**Author**: Anthony (with Claude Code)
**Version**: 1.0
