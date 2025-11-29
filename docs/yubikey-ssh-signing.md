# YubiKey SSH Commit Signing Guide

This guide explains how to generate an SSH FIDO2 key on your YubiKey and use it for signing Git commits.

## Overview

SSH commit signing with YubiKey provides:
- **Hardware-backed security**: Private key never leaves the YubiKey
- **Physical touch requirement**: Must touch YubiKey for each commit
- **Resident keys**: Key stored on YubiKey, discoverable across machines
- **PIN protection**: Optional PIN requirement for additional security
- **Simpler than GPG**: No complex key management or daemon setup

## Prerequisites

1. YubiKey 5 or later (with FIDO2 support)
2. OpenSSH 8.2 or later (for FIDO2 support)
3. NixOS configuration already includes necessary packages

Check your OpenSSH version:
```bash
ssh -V
# Should show OpenSSH_8.2 or higher
```

## Step 1: Generate YubiKey FIDO2 SSH Key

Generate a resident FIDO2 key on your YubiKey:

```bash
# Navigate to SSH directory
cd ~/.ssh

# Generate ed25519-sk (FIDO2) resident key
ssh-keygen -t ed25519-sk -O resident -O verify-required -C "git-signing-yubikey"
```

**Command breakdown:**
- `-t ed25519-sk`: Use Ed25519 algorithm with security key (sk)
- `-O resident`: Store key on YubiKey (discoverable/resident key)
- `-O verify-required`: Require PIN verification (recommended)
- `-C "git-signing-yubikey"`: Comment to identify the key

**During generation:**
1. You'll be asked to touch your YubiKey
2. You may be prompted to set/enter your YubiKey PIN
3. Touch YubiKey again to confirm

**Files created:**
- `~/.ssh/id_ed25519_sk` - Private key handle (safe to backup)
- `~/.ssh/id_ed25519_sk.pub` - Public key (for Git and GitHub)

**Important:** The actual private key is stored on the YubiKey. The `id_ed25519_sk` file just contains a handle/reference to the key on the device.

## Step 2: Verify Key Generation

Check that your key was created:

```bash
ls -la ~/.ssh/id_ed25519_sk*
cat ~/.ssh/id_ed25519_sk.pub
```

The public key should start with `sk-ssh-ed25519@openssh.com`.

## Step 3: Apply NixOS Configuration

Your dotfiles are already configured for YubiKey SSH signing. Apply the changes:

```bash
# Rebuild home-manager configuration
home-manager switch

# Or if using NixOS with home-manager
sudo nixos-rebuild switch
# or
nh os switch
```

This will:
- Configure Git to use SSH signing format
- Set signing key to `~/.ssh/id_ed25519_sk.pub`
- Enable automatic commit signing
- Generate the allowed_signers file for verification

## Step 4: Test Commit Signing

Test that signing works:

```bash
# Navigate to any git repository
cd ~/dotfiles

# Make a test commit
git commit --allow-empty -m "Test YubiKey SSH signing"
```

**You should:**
1. See a prompt to touch your YubiKey
2. Touch the YubiKey (it will blink)
3. Possibly enter your YubiKey PIN (if verify-required was used)
4. Commit succeeds

**Verify the signature:**
```bash
# Show the signature on the last commit
git log --show-signature -1

# You should see:
# Good "git" signature for AnthonyMBonafide@pm.me with ED25519-SK key...
```

## Step 5: Add Public Key to GitHub/GitLab

For GitHub to show "Verified" badges on your commits:

### GitHub:

1. Copy your public key:
   ```bash
   cat ~/.ssh/id_ed25519_sk.pub
   ```

2. Go to GitHub → Settings → SSH and GPG keys
3. Click "New SSH key"
4. Choose **"Signing Key"** as the key type (important!)
5. Paste your public key
6. Click "Add SSH key"

### GitLab:

1. Copy your public key:
   ```bash
   cat ~/.ssh/id_ed25519_sk.pub
   ```

2. Go to GitLab → Preferences → SSH Keys
3. Paste your public key
4. Check "Signing key" usage type
5. Click "Add key"

## Step 6: Push and Verify on GitHub

Push a signed commit and verify it shows as verified:

```bash
git push
```

On GitHub, your commit should now show a green "Verified" badge.

## Multiple YubiKeys (Recommended)

If you have multiple YubiKeys (for backup), generate keys on each:

```bash
# For second YubiKey
ssh-keygen -t ed25519-sk -O resident -O verify-required -C "git-signing-yubikey-backup"
# Save as: ~/.ssh/id_ed25519_sk_backup

# Add to GitHub/GitLab as additional signing keys
```

You can specify which key to use per-repository:
```bash
git config user.signingkey ~/.ssh/id_ed25519_sk_backup.pub
```

## Recovering Keys on New Machine

Since resident keys are stored on the YubiKey, you can recover them:

```bash
# Download resident keys from YubiKey
ssh-keygen -K

# This creates id_ed25519_sk_rk files
# Rename to id_ed25519_sk if needed
mv id_ed25519_sk_rk ~/.ssh/id_ed25519_sk
mv id_ed25519_sk_rk.pub ~/.ssh/id_ed25519_sk.pub
chmod 600 ~/.ssh/id_ed25519_sk
```

Then rebuild your home-manager configuration, and you're ready to sign commits.

## Troubleshooting

### Error: "error: gpg failed to sign the data"

This usually means the YubiKey isn't connected or the key doesn't exist.

**Check:**
```bash
# Is YubiKey connected?
lsusb | grep Yubico

# Does the key file exist?
ls -la ~/.ssh/id_ed25519_sk.pub

# Test SSH key directly
ssh-keygen -Y sign -f ~/.ssh/id_ed25519_sk -n file test.txt
```

### Error: "signing failed: agent refused operation"

Your YubiKey might be locked or require PIN entry.

**Solution:**
- Unplug and replug YubiKey
- Touch YubiKey when it blinks
- Enter PIN if prompted

### Error: "Key not found on security key"

The key might have been generated without `-O resident` flag, or on a different YubiKey.

**Solution:**
- Generate a new resident key with `-O resident` flag
- Or, make sure you're using the correct YubiKey

### Git doesn't ask for YubiKey touch

Check that signing is enabled:
```bash
git config --get commit.gpgsign
# Should return: true

git config --get gpg.format
# Should return: ssh

git config --get user.signingkey
# Should return: ~/.ssh/id_ed25519_sk.pub or full path
```

### Signature shows "Good signature" but GitHub shows "Unverified"

You need to add the public key as a **Signing Key** (not Authentication Key) to GitHub.

## Security Considerations

### PIN vs No-PIN

**With PIN (`-O verify-required`):**
- ✅ Requires both physical possession AND knowledge (PIN)
- ✅ Prevents unauthorized signing if YubiKey is stolen
- ❌ More friction for frequent commits

**Without PIN:**
- ✅ Faster workflow, just touch required
- ❌ Anyone with physical access to YubiKey can sign
- ⚠️ Still requires physical touch (can't be used remotely)

**Recommendation:** Use PIN for maximum security, especially if YubiKey contains other sensitive credentials.

### Best Practices

1. **Generate on multiple YubiKeys** - Have a backup YubiKey with the same key
2. **Use resident keys** - Makes recovery on new machines easier
3. **Keep YubiKey accessible** - You'll need it for every commit
4. **Don't commit the private key handle to Git** - It's in `~/.ssh/`, keep it private
5. **Backup the key handle** - Store `id_ed25519_sk` securely (not the public key)

### What if I lose my YubiKey?

1. **Your old commits remain valid** - Signatures are verified against the public key on GitHub
2. **Generate new key on backup YubiKey** - If you have one
3. **Or generate new regular key** - Switch back to non-YubiKey signing temporarily
4. **Update GitHub** - Remove lost YubiKey's public key, add new one

## Comparison: SSH vs GPG Signing

| Feature | SSH Signing (YubiKey) | GPG Signing (YubiKey) |
|---------|----------------------|----------------------|
| Setup complexity | ⭐⭐ Simple | ⭐⭐⭐⭐⭐ Complex |
| GitHub/GitLab support | ✅ Full support | ✅ Full support |
| Key management | Simple | Complex (master key, subkeys) |
| Daemon required | No | Yes (gpg-agent) |
| Touch required | Yes | Yes |
| PIN required | Optional | Optional |
| Resident keys | Yes | No |
| Cross-machine recovery | Easy | Hard |
| Encryption support | No (signing only) | Yes (signing + encryption) |

**Recommendation:** SSH signing is simpler and sufficient for most use cases. Use GPG only if you need email encryption or other GPG features.

## Additional Resources

- [GitHub: SSH Commit Signature Verification](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#ssh-commit-signature-verification)
- [Git Documentation: Signing Commits](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)
- [OpenSSH FIDO/U2F Key Support](https://www.openssh.com/txt/release-8.2)
- [Yubico: SSH with FIDO2](https://developers.yubico.com/SSH/)

## Summary

You now have:
- ✅ YubiKey FIDO2 SSH key generated
- ✅ Git configured for automatic SSH signing
- ✅ Touch-required commit signing
- ✅ GitHub/GitLab verification support
- ✅ Resident keys for easy recovery

Every commit you make will now require touching your YubiKey and show as "Verified" on GitHub!
