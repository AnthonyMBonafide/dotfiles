#!/usr/bin/env bash
# Re-encrypt All SOPS Secrets
# Use this after adding/removing YubiKeys from .sops.yaml

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }

DOTFILES_ROOT="/home/anthony/dotfiles"
SECRETS_DIR="${DOTFILES_ROOT}/secrets"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  SOPS Secrets Re-encryption${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

warn "This will re-encrypt all secrets with the keys defined in .sops.yaml"
warn "Make sure you have:"
warn "  1. Updated .sops.yaml with new/removed keys"
warn "  2. Have a YubiKey or backup key available to decrypt"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Re-encryption cancelled"
    exit 0
fi

# Find all encrypted files
encrypted_files=()
while IFS= read -r -d '' file; do
    # Only process SOPS-encrypted files (yaml/json)
    if [[ "$file" =~ \.(yaml|json)$ ]]; then
        # Verify it's a SOPS file by checking for sops metadata
        if grep -q "sops:" "$file" 2>/dev/null || grep -q "\"sops\":" "$file" 2>/dev/null; then
            encrypted_files+=("$file")
        fi
    fi
done < <(find "$SECRETS_DIR" -type f -print0)

if [[ ${#encrypted_files[@]} -eq 0 ]]; then
    warn "No SOPS-encrypted files found in $SECRETS_DIR"
    exit 0
fi

info "Found ${#encrypted_files[@]} encrypted file(s) to re-encrypt"
echo ""

# Create backup
backup_dir="$SECRETS_DIR/backups/rekey-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"
info "Creating backup in: $backup_dir"

for file in "${encrypted_files[@]}"; do
    cp "$file" "$backup_dir/"
done
success "Backup created"
echo ""

# Re-encrypt each file
failed=0
for file in "${encrypted_files[@]}"; do
    relative_path="${file#$DOTFILES_ROOT/}"
    info "Re-encrypting: $relative_path"

    # Use sops updatekeys to re-encrypt with new keys from .sops.yaml
    if sops updatekeys --yes "$file" 2>&1 | grep -v "^$"; then
        success "  ✓ Re-encrypted successfully"
    else
        error "  ✗ Re-encryption FAILED"
        failed=1
    fi
done

echo ""
if [[ $failed -eq 0 ]]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  All secrets re-encrypted successfully!              ║${NC}"
    echo -e "${GREEN}║  Backup saved in: $backup_dir                          ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    info "Next steps:"
    echo "  1. Test decryption: ./scripts/test-yubikey-decrypt.sh"
    echo "  2. Commit updated secrets: git add secrets/ && git commit"
    exit 0
else
    echo -e "${RED}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  Some secrets failed to re-encrypt!                  ║${NC}"
    echo -e "${RED}║  Check errors above. Backup is in:                   ║${NC}"
    echo -e "${RED}║  $backup_dir                                            ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════╝${NC}"
    exit 1
fi
