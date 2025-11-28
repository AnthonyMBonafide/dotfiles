#!/usr/bin/env bash
# YubiKey SOPS Secrets Management Script
# Comprehensive tool for managing SSH keys encrypted with SOPS and YubiKey age keys

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_ROOT="/home/anthony/dotfiles"
SECRETS_DIR="${DOTFILES_ROOT}/secrets"
SSH_SECRETS_DIR="${SECRETS_DIR}/ssh"
SOPS_CONFIG="${DOTFILES_ROOT}/.sops.yaml"
BACKUP_KEY_FILE="${SECRETS_DIR}/backup-key.age"
BACKUP_KEY_ENC="${SECRETS_DIR}/backup-key.age.enc"

# Helper functions
info() {
    echo -e "${BLUE}ℹ${NC} $*"
}

success() {
    echo -e "${GREEN}✓${NC} $*"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $*"
}

error() {
    echo -e "${RED}✗${NC} $*"
}

header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $*${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

# Check dependencies
check_dependencies() {
    local missing=0

    for cmd in age age-plugin-yubikey sops ssh-keygen; do
        if ! command -v "$cmd" &> /dev/null; then
            error "Required command not found: $cmd"
            missing=1
        fi
    done

    if [[ $missing -eq 1 ]]; then
        error "Missing dependencies. Please run: nix-shell -p age age-plugin-yubikey sops"
        exit 1
    fi
}

# Check if YubiKey is present
check_yubikey() {
    # Check if YubiKey hardware is detected using ykman
    if ! ykman list &> /dev/null; then
        error "No YubiKey detected. Please insert a YubiKey and try again."
        return 1
    fi

    # Check if PIV application is accessible
    if ! ykman piv info &> /dev/null; then
        error "YubiKey PIV application not accessible."
        return 1
    fi

    return 0
}

# Initialize - First time setup
init_setup() {
    header "YubiKey SOPS Secrets - Initial Setup"

    info "This wizard will help you:"
    echo "  1. Generate age keys on your YubiKeys"
    echo "  2. Create a backup age key"
    echo "  3. Configure .sops.yaml"
    echo "  4. Generate SSH keys"
    echo "  5. Encrypt SSH keys with SOPS"
    echo ""

    read -p "Continue with initialization? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Initialization cancelled."
        exit 0
    fi

    # Step 1: Generate YubiKey age keys
    header "Step 1: Generate Age Keys on YubiKeys"
    info "You will need to insert each YubiKey and generate an age key."
    info "The age plugin will use PIV slot 9a (authentication)."
    echo ""

    declare -a yubikey_pubkeys

    for i in 1 2 3; do
        echo ""
        read -p "Insert YubiKey #$i and press Enter..."

        if ! check_yubikey; then
            error "YubiKey not detected. Skipping..."
            continue
        fi

        # Configure YubiKey PIV management key for age-plugin-yubikey compatibility
        info "Configuring YubiKey PIV management key..."
        info "Press Enter at the prompt to use the default management key"
        echo ""

        if ykman piv access change-management-key -a TDES --protect; then
            success "Management key configured successfully"
        else
            warn "Management key may already be configured, continuing..."
        fi

        echo ""

        info "Generating age key for YubiKey #$i..."
        info "You will be prompted for your YubiKey PIN..."
        info "You may also need to touch your YubiKey..."
        echo ""
        warn "After generation completes, copy the 'Recipient:' line (starting with 'age1...')"
        echo ""

        # Generate age identity using YubiKey PIV
        # Run directly without capturing to maintain TTY access
        age-plugin-yubikey --generate

        echo ""
        read -p "Enter the recipient (age public key starting with age1...): " pubkey

        if [[ -n "$pubkey" && "$pubkey" =~ ^age1 ]]; then
            yubikey_pubkeys+=("$pubkey")
            success "YubiKey #$i age public key: $pubkey"
        else
            error "Invalid or empty age key. Skipping YubiKey #$i"
        fi
    done

    if [[ ${#yubikey_pubkeys[@]} -eq 0 ]]; then
        error "No YubiKey age keys were generated. Cannot continue."
        exit 1
    fi

    success "Generated ${#yubikey_pubkeys[@]} YubiKey age keys"

    # Step 2: Generate backup age key
    header "Step 2: Generate Backup Age Key"
    info "Creating a backup age key for disaster recovery..."
    echo ""

    mkdir -p "$SECRETS_DIR"

    # Generate backup age key
    age-keygen -o "$BACKUP_KEY_FILE" 2>&1

    # Extract public key
    backup_pubkey=$(grep "# public key:" "$BACKUP_KEY_FILE" | awk '{print $4}')
    success "Backup age public key: $backup_pubkey"

    # Encrypt backup key with password
    info "Encrypting backup key with password..."
    warn "You will be prompted to enter a passphrase TWICE"
    warn "Make sure both entries match exactly!"
    echo ""

    # Try encryption with better error handling
    if age -p -o "$BACKUP_KEY_ENC" "$BACKUP_KEY_FILE" 2>&1; then
        # Securely remove unencrypted backup key
        shred -u "$BACKUP_KEY_FILE"
        success "Backup key encrypted and saved to: $BACKUP_KEY_ENC"
        echo ""
        warn "IMPORTANT: Store this password in your password manager!"
        warn "The password is required to decrypt the backup age key."
    else
        error "Failed to encrypt backup key!"
        error "The passphrases may not have matched or encryption failed."
        echo ""
        read -p "Do you want to try again? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            info "Trying again..."
            if age -p -o "$BACKUP_KEY_ENC" "$BACKUP_KEY_FILE" 2>&1; then
                shred -u "$BACKUP_KEY_FILE"
                success "Backup key encrypted successfully!"
            else
                error "Encryption failed again. Keeping unencrypted backup key at: $BACKUP_KEY_FILE"
                warn "You can manually encrypt it later with: age -p -o $BACKUP_KEY_ENC $BACKUP_KEY_FILE"
                # Don't delete the unencrypted key if encryption failed
            fi
        else
            error "Keeping unencrypted backup key at: $BACKUP_KEY_FILE"
            warn "You MUST encrypt this manually later: age -p -o $BACKUP_KEY_ENC $BACKUP_KEY_FILE"
        fi
    fi

    # Step 3: Configure .sops.yaml
    header "Step 3: Configure .sops.yaml"

    info "Updating .sops.yaml with generated age public keys..."

    # Create .sops.yaml with actual keys
    cat > "$SOPS_CONFIG" <<EOF
# SOPS Configuration File
# This file defines which keys can encrypt/decrypt secrets

# Age key recipients (YubiKeys + backup key)
keys:
EOF

    # Add YubiKey keys
    for i in "${!yubikey_pubkeys[@]}"; do
        echo "  - &yubikey$((i+1)) ${yubikey_pubkeys[$i]}  # YubiKey $((i+1))" >> "$SOPS_CONFIG"
    done

    # Add backup key
    echo "  - &backup $backup_pubkey  # Backup key (password-protected)" >> "$SOPS_CONFIG"

    # Add creation rules
    cat >> "$SOPS_CONFIG" <<EOF

# Creation rules define which keys can decrypt which files
creation_rules:
  # SSH keys - can be decrypted by any YubiKey or the backup key
  - path_regex: secrets/ssh/.*
    age: >-
EOF

    # Build age recipients list
    age_list=""
    for key in "${yubikey_pubkeys[@]}"; do
        age_list+="$key,"
    done
    age_list+="$backup_pubkey"

    echo "      $age_list" >> "$SOPS_CONFIG"

    cat >> "$SOPS_CONFIG" <<EOF

  # Default rule for all other secrets
  - path_regex: secrets/.*
    age: >-
      $age_list
EOF

    success ".sops.yaml configured with ${#yubikey_pubkeys[@]} YubiKeys and 1 backup key"

    # Step 4: Generate SSH keys
    header "Step 4: Generate SSH Keys"

    info "Generating SSH keys..."
    mkdir -p "$SSH_SECRETS_DIR"

    # Check if personal key exists
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        warn "Personal SSH key not found at ~/.ssh/id_ed25519"
        read -p "Generate new personal SSH key? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "anthony@personal" -N ""
            success "Generated new personal SSH key"
        fi
    else
        info "Using existing personal SSH key"
    fi

    # Generate host-specific keys
    info "Generating host-specific SSH keys..."

    # nixos laptop key
    if [[ ! -f "$SSH_SECRETS_DIR/nixos_ed25519.tmp" ]]; then
        ssh-keygen -t ed25519 -f "$SSH_SECRETS_DIR/nixos_ed25519.tmp" -C "anthony@nixos" -N ""
        success "Generated nixos host key"
    fi

    # black-mesa desktop key
    if [[ ! -f "$SSH_SECRETS_DIR/black-mesa_ed25519.tmp" ]]; then
        ssh-keygen -t ed25519 -f "$SSH_SECRETS_DIR/black-mesa_ed25519.tmp" -C "anthony@black-mesa" -N ""
        success "Generated black-mesa host key"
    fi

    # Step 5: Encrypt SSH keys with SOPS
    header "Step 5: Encrypt SSH Keys with SOPS"

    info "Encrypting SSH keys with SOPS..."

    read -p "Insert a YubiKey that you just configured and press Enter..."

    # Export SOPS age recipients
    export SOPS_AGE_RECIPIENTS="$(echo "${yubikey_pubkeys[@]} $backup_pubkey" | tr ' ' ',')"

    # Encrypt personal key
    if [[ -f ~/.ssh/id_ed25519 ]]; then
        info "Encrypting personal SSH key..."
        # Create a temporary YAML file with the SSH key content
        cat > "$SSH_SECRETS_DIR/id_ed25519.yaml.tmp" <<EOF
data: |
$(sed 's/^/  /' ~/.ssh/id_ed25519)
EOF
        # Encrypt with SOPS
        sops -e "$SSH_SECRETS_DIR/id_ed25519.yaml.tmp" > "$SSH_SECRETS_DIR/id_ed25519.yaml"
        rm -f "$SSH_SECRETS_DIR/id_ed25519.yaml.tmp"
        success "Encrypted: id_ed25519"
    fi

    # Encrypt host keys
    for host in nixos black-mesa; do
        if [[ -f "$SSH_SECRETS_DIR/${host}_ed25519.tmp" ]]; then
            info "Encrypting ${host} SSH key..."
            # Create a temporary YAML file with the SSH key content
            cat > "$SSH_SECRETS_DIR/${host}_ed25519.yaml.tmp" <<EOF
data: |
$(sed 's/^/  /' "$SSH_SECRETS_DIR/${host}_ed25519.tmp")
EOF
            # Encrypt with SOPS
            sops -e "$SSH_SECRETS_DIR/${host}_ed25519.yaml.tmp" > "$SSH_SECRETS_DIR/${host}_ed25519.yaml"
            # Remove temporary files
            rm -f "$SSH_SECRETS_DIR/${host}_ed25519.yaml.tmp"
            shred -u "$SSH_SECRETS_DIR/${host}_ed25519.tmp" "$SSH_SECRETS_DIR/${host}_ed25519.tmp.pub"
            success "Encrypted: ${host}_ed25519"
        fi
    done

    header "Initialization Complete!"
    success "YubiKey SOPS secrets system is now configured!"
    echo ""
    info "Next steps:"
    echo "  1. Test decryption: ./scripts/test-yubikey-decrypt.sh"
    echo "  2. Rebuild your system: sudo nixos-rebuild switch --flake ."
    echo "  3. Verify SSH keys are deployed to ~/.ssh/"
    echo ""
    warn "IMPORTANT: Backup the encrypted backup key:"
    echo "  File: $BACKUP_KEY_ENC"
    echo "  Store in password manager or secure location"
}

# Enroll YubiKey - Add/remove YubiKeys
enroll_yubikey() {
    header "YubiKey Enrollment"

    echo "1. Add new YubiKey"
    echo "2. Remove YubiKey"
    echo "3. List enrolled YubiKeys"
    echo "4. Back to main menu"
    echo ""
    read -p "Select option: " choice

    case $choice in
        1) enroll_add_yubikey ;;
        2) enroll_remove_yubikey ;;
        3) enroll_list_yubikeys ;;
        4) return ;;
        *) error "Invalid option" ;;
    esac
}

enroll_add_yubikey() {
    info "Adding new YubiKey to SOPS configuration..."

    read -p "Insert the new YubiKey and press Enter..."

    if ! check_yubikey; then
        return 1
    fi

    info "Generating age key for new YubiKey..."
    pubkey=$(age-plugin-yubikey --generate 2>&1 | grep -oP 'age1\w+' | head -1)

    if [[ -z "$pubkey" ]]; then
        error "Failed to generate age key"
        return 1
    fi

    success "New YubiKey age public key: $pubkey"

    warn "You must manually add this key to $SOPS_CONFIG"
    warn "Then re-encrypt all secrets with: ./scripts/rekey-secrets.sh"
}

enroll_remove_yubikey() {
    warn "Removing a YubiKey from SOPS configuration..."
    warn "You must manually remove the key from $SOPS_CONFIG"
    warn "Then re-encrypt all secrets with: ./scripts/rekey-secrets.sh"
}

enroll_list_yubikeys() {
    info "Enrolled YubiKeys (from $SOPS_CONFIG):"
    grep "age1" "$SOPS_CONFIG" | grep -v "^#" | grep -v "path_regex" | grep -v "age:"
}

# Rotate secrets - Generate new SSH keys and re-encrypt
rotate_secrets() {
    header "Rotate SSH Keys"

    warn "This will generate NEW SSH keys and re-encrypt them."
    warn "OLD SSH keys will be backed up."
    echo ""
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi

    # Backup existing keys
    backup_dir="$SECRETS_DIR/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"

    info "Backing up existing encrypted keys to $backup_dir"
    cp -r "$SSH_SECRETS_DIR"/*.yaml "$backup_dir/" 2>/dev/null || true

    # Generate new SSH keys
    info "Generating new SSH keys..."

    for host in nixos black-mesa; do
        ssh-keygen -t ed25519 -f "$SSH_SECRETS_DIR/${host}_ed25519.tmp" -C "anthony@${host}" -N ""
        success "Generated new ${host} key"
    done

    # Re-encrypt
    info "Re-encrypting with SOPS..."

    for host in nixos black-mesa; do
        sops -e "$SSH_SECRETS_DIR/${host}_ed25519.tmp" > "$SSH_SECRETS_DIR/${host}_ed25519.yaml"
        shred -u "$SSH_SECRETS_DIR/${host}_ed25519.tmp" "$SSH_SECRETS_DIR/${host}_ed25519.tmp.pub"
        success "Encrypted: ${host}_ed25519"
    done

    success "SSH keys rotated successfully!"
    warn "Remember to update public keys on GitHub/servers"
    warn "Rebuild system to deploy new keys: sudo nixos-rebuild switch --flake ."
}

# Backup and recovery
backup_recovery() {
    header "Backup and Recovery"

    echo "1. Test decrypt with backup key"
    echo "2. Export secrets (for manual backup)"
    echo "3. Verify all secrets can be decrypted"
    echo "4. Back to main menu"
    echo ""
    read -p "Select option: " choice

    case $choice in
        1) test_backup_key ;;
        2) export_secrets ;;
        3) verify_secrets ;;
        4) return ;;
        *) error "Invalid option" ;;
    esac
}

test_backup_key() {
    info "Testing backup key decryption..."

    if [[ ! -f "$BACKUP_KEY_ENC" ]]; then
        error "Encrypted backup key not found: $BACKUP_KEY_ENC"
        return 1
    fi

    info "Decrypting backup age key..."
    echo "Enter backup key password:"
    age -d "$BACKUP_KEY_ENC" > "$BACKUP_KEY_FILE.tmp"

    # Try to decrypt a test secret
    if [[ -f "$SSH_SECRETS_DIR/id_ed25519.yaml" ]]; then
        info "Testing secret decryption with backup key..."
        SOPS_AGE_KEY_FILE="$BACKUP_KEY_FILE.tmp" sops -d "$SSH_SECRETS_DIR/id_ed25519.yaml" > /dev/null
        success "Backup key can decrypt secrets!"
    else
        warn "No secrets found to test"
    fi

    # Clean up
    shred -u "$BACKUP_KEY_FILE.tmp"
}

export_secrets() {
    warn "This will decrypt and export all secrets to a temporary directory."
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi

    export_dir="/tmp/sops-secrets-export-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$export_dir"

    info "Exporting secrets to $export_dir"

    for secret in "$SSH_SECRETS_DIR"/*.yaml; do
        if [[ -f "$secret" ]]; then
            basename=$(basename "$secret" .yaml)
            sops -d "$secret" > "$export_dir/$basename"
            success "Exported: $basename"
        fi
    done

    success "Secrets exported to: $export_dir"
    warn "REMEMBER TO DELETE THIS DIRECTORY WHEN DONE!"
}

verify_secrets() {
    info "Verifying all secrets can be decrypted..."

    local failed=0

    for secret in "$SSH_SECRETS_DIR"/*.yaml; do
        if [[ -f "$secret" ]]; then
            basename=$(basename "$secret")
            if sops -d "$secret" > /dev/null 2>&1; then
                success "$basename: OK"
            else
                error "$basename: FAILED"
                failed=1
            fi
        fi
    done

    if [[ $failed -eq 0 ]]; then
        success "All secrets verified successfully!"
    else
        error "Some secrets failed verification"
    fi
}

# Main menu
main_menu() {
    while true; do
        header "YubiKey SOPS Secrets Management"

        echo "1. Initialize (first-time setup)"
        echo "2. Enroll/Remove YubiKeys"
        echo "3. Rotate SSH keys"
        echo "4. Backup & Recovery"
        echo "5. Exit"
        echo ""
        read -p "Select option: " choice

        case $choice in
            1) init_setup ;;
            2) enroll_yubikey ;;
            3) rotate_secrets ;;
            4) backup_recovery ;;
            5) exit 0 ;;
            *) error "Invalid option" ;;
        esac
    done
}

# Main execution
check_dependencies

if [[ $# -eq 0 ]]; then
    main_menu
else
    case "$1" in
        init) init_setup ;;
        enroll) enroll_yubikey ;;
        rotate) rotate_secrets ;;
        backup) backup_recovery ;;
        *)
            echo "Usage: $0 [init|enroll|rotate|backup]"
            exit 1
            ;;
    esac
fi
