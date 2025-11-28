#!/usr/bin/env bash
#
# YubiKey LUKS Enrollment Helper Script
#
# This script guides you through enrolling YubiKey(s) for LUKS disk decryption
# using FIDO2 on NixOS systems.
#
# Usage:
#   ./enroll-yubikey.sh [--hostname HOSTNAME]
#
# Options:
#   --hostname    Specify hostname (black-mesa or nixos). If not provided, will auto-detect.
#
# For detailed information, see: docs/yubikey-luks-enrollment.md

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Detect hostname
detect_hostname() {
    local detected_hostname=$(hostname)

    case "$detected_hostname" in
        black-mesa)
            echo "black-mesa"
            ;;
        nixos)
            echo "nixos"
            ;;
        *)
            print_warning "Unknown hostname: $detected_hostname"
            echo "unknown"
            ;;
    esac
}

# Get LUKS UUID for hostname
get_luks_uuid() {
    local hostname=$1

    case "$hostname" in
        black-mesa)
            echo "29509493-cf8a-43ad-aafe-421a456ba58a"
            ;;
        nixos)
            echo "f4e3d6cf-2405-48f7-9b30-2c7de8b0b2c8"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Check if YubiKey is connected
check_yubikey() {
    print_info "Checking for connected YubiKey..."

    if ! command -v ykman &> /dev/null; then
        print_error "ykman (YubiKey Manager) not found. Please install it first."
        exit 1
    fi

    if ykman list &> /dev/null; then
        local yubikey_info=$(ykman list)
        print_success "YubiKey detected: $yubikey_info"
        return 0
    else
        print_warning "No YubiKey detected. Please insert a YubiKey and try again."
        return 1
    fi
}

# Check LUKS version
check_luks_version() {
    local uuid=$1
    local device="/dev/disk/by-uuid/$uuid"

    print_info "Checking LUKS version for device $uuid..."

    if [[ ! -e "$device" ]]; then
        print_error "LUKS device not found: $device"
        exit 1
    fi

    local version=$(cryptsetup luksDump "$device" | grep "^Version:" | awk '{print $2}')

    if [[ "$version" == "2" ]]; then
        print_success "LUKS version 2 detected (required for FIDO2)"
        return 0
    else
        print_error "LUKS version $version detected. LUKS2 is required for FIDO2 support."
        print_info "To convert to LUKS2, run (BACKUP YOUR DATA FIRST!):"
        print_info "  sudo cryptsetup convert --type luks2 $device"
        exit 1
    fi
}

# Show current LUKS slots and tokens
show_luks_info() {
    local uuid=$1
    local device="/dev/disk/by-uuid/$uuid"

    print_header "Current LUKS Configuration"

    print_info "Key slots:"
    cryptsetup luksDump "$device" | grep -A 1 "Keyslots:" | tail -n +2 | head -n 10

    echo ""
    print_info "Tokens:"
    local tokens=$(cryptsetup luksDump "$device" | grep -A 5 "Tokens:")
    if [[ -n "$tokens" ]]; then
        echo "$tokens"
    else
        print_warning "No tokens enrolled yet"
    fi
}

# Enroll YubiKey
enroll_yubikey() {
    local uuid=$1
    local device="/dev/disk/by-uuid/$uuid"

    print_header "YubiKey Enrollment"

    print_info "This will enroll the connected YubiKey for LUKS decryption."
    print_warning "You will be prompted for:"
    echo "  1. Your current LUKS password"
    echo "  2. Your YubiKey PIN"
    echo ""

    read -p "Continue with enrollment? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Enrollment cancelled."
        return 1
    fi

    print_info "Starting enrollment..."
    echo ""

    if systemd-cryptenroll --fido2-device=auto \
        --fido2-with-user-verification=true \
        --fido2-with-user-presence=false \
        "$device"; then
        print_success "YubiKey enrolled successfully!"
        return 0
    else
        print_error "Enrollment failed. Please check the error messages above."
        return 1
    fi
}

# Main enrollment flow
main_enrollment() {
    local hostname=$1
    local uuid=$2

    print_header "YubiKey LUKS Enrollment Helper"
    print_info "Hostname: $hostname"
    print_info "LUKS UUID: $uuid"
    echo ""

    # Check for YubiKey
    if ! check_yubikey; then
        exit 1
    fi

    echo ""

    # Check LUKS version
    check_luks_version "$uuid"

    echo ""

    # Show current configuration
    show_luks_info "$uuid"

    echo ""

    # Enroll YubiKey
    if enroll_yubikey "$uuid"; then
        echo ""
        print_header "Post-Enrollment Information"
        show_luks_info "$uuid"

        echo ""
        print_success "Enrollment complete!"
        echo ""
        print_info "Next steps:"
        echo "  1. To enroll additional YubiKeys, remove the current one, insert another, and run this script again"
        echo "  2. Reboot your system to test the YubiKey unlock"
        echo "  3. Verify password fallback works (reboot without YubiKey)"
        echo ""
        print_info "For detailed testing instructions, see: docs/yubikey-luks-enrollment.md"

        echo ""
        read -p "Would you like to enroll another YubiKey now? (y/N): " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Please remove the current YubiKey and insert the next one..."
            read -p "Press Enter when ready..." -r
            main_enrollment "$hostname" "$uuid"
        fi
    else
        exit 1
    fi
}

# Parse command line arguments
HOSTNAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --hostname)
            HOSTNAME="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [--hostname HOSTNAME]"
            echo ""
            echo "Options:"
            echo "  --hostname    Specify hostname (black-mesa or nixos)"
            echo "  -h, --help    Show this help message"
            echo ""
            echo "For detailed information, see: docs/yubikey-luks-enrollment.md"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Main execution
check_root

# Detect or validate hostname
if [[ -z "$HOSTNAME" ]]; then
    HOSTNAME=$(detect_hostname)
    if [[ "$HOSTNAME" == "unknown" ]]; then
        print_error "Could not auto-detect hostname. Please specify with --hostname"
        exit 1
    fi
fi

# Get LUKS UUID for hostname
UUID=$(get_luks_uuid "$HOSTNAME")

if [[ -z "$UUID" ]]; then
    print_error "Unknown hostname: $HOSTNAME"
    print_info "Supported hostnames: black-mesa, nixos"
    exit 1
fi

# Run main enrollment flow
main_enrollment "$HOSTNAME" "$UUID"
