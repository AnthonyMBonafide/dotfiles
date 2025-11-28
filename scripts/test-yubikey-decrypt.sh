#!/usr/bin/env bash
# Test YubiKey SOPS Decryption
# Verifies that the inserted YubiKey can decrypt SOPS secrets

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
SSH_SECRETS_DIR="${DOTFILES_ROOT}/secrets/ssh"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  YubiKey SOPS Decryption Test${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Check for YubiKey
info "Checking for YubiKey..."
if ! age-plugin-yubikey --list &> /dev/null; then
    error "No YubiKey detected!"
    echo "  Please insert a YubiKey and try again."
    exit 1
fi
success "YubiKey detected"

# List available YubiKeys
info "Available YubiKeys:"
age-plugin-yubikey --list 2>&1 | grep -E "(Serial|age1)" || true
echo ""

# Find secrets to test
secrets=()
if [[ -d "$SSH_SECRETS_DIR" ]]; then
    while IFS= read -r -d '' file; do
        secrets+=("$file")
    done < <(find "$SSH_SECRETS_DIR" -name "*.yaml" -type f -print0)
fi

if [[ ${#secrets[@]} -eq 0 ]]; then
    warn "No encrypted secrets found in $SSH_SECRETS_DIR"
    echo "  Run ./scripts/manage-yubikey-secrets.sh init first"
    exit 1
fi

info "Found ${#secrets[@]} encrypted secret(s)"
echo ""

# Test each secret
failed=0
for secret in "${secrets[@]}"; do
    basename=$(basename "$secret")
    info "Testing: $basename"

    if sops -d "$secret" > /dev/null 2>&1; then
        success "  ✓ Decryption successful"
    else
        error "  ✗ Decryption FAILED"
        failed=1
    fi
done

echo ""
if [[ $failed -eq 0 ]]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  All secrets decrypted successfully!                 ║${NC}"
    echo -e "${GREEN}║  Your YubiKey is properly configured for SOPS.       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    exit 0
else
    echo -e "${RED}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  Some secrets failed to decrypt!                     ║${NC}"
    echo -e "${RED}║  This YubiKey may not be enrolled in .sops.yaml      ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════╝${NC}"
    exit 1
fi
