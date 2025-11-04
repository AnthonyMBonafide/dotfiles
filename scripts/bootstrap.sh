#!/usr/bin/env bash

# Bootstrap script for dotfiles installation
# Detects environment and installs using the best available method

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            echo "$ID"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Detect architecture
detect_arch() {
    case $(uname -m) in
        x86_64|amd64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "aarch64"
            ;;
        armv7l)
            echo "armv7"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if Nix is available
has_nix() {
    command -v nix >/dev/null 2>&1
}

# Check if package manager is available
has_command() {
    command -v "$1" >/dev/null 2>&1
}

# Get Nix system identifier
get_nix_system() {
    local os=$(detect_os)
    local arch=$(detect_arch)

    if [ "$os" = "macos" ]; then
        if [ "$arch" = "aarch64" ]; then
            echo "aarch64-darwin"
        else
            echo "x86_64-darwin"
        fi
    elif [ "$os" = "arch" ] || [ "$os" = "manjaro" ] || [[ "$os" =~ "endeavour" ]]; then
        if [ "$arch" = "aarch64" ]; then
            echo "aarch64-linux"
        else
            echo "x86_64-linux"
        fi
    else
        # Generic Linux
        if [ "$arch" = "aarch64" ]; then
            echo "aarch64-linux"
        else
            echo "x86_64-linux"
        fi
    fi
}

# Get appropriate host config name
get_host_config() {
    local os=$(detect_os)
    local arch=$(detect_arch)

    if [ "$os" = "macos" ]; then
        echo "macbook-pro"
    elif [ "$os" = "arch" ] || [ "$os" = "manjaro" ] || [[ "$os" =~ "endeavour" ]]; then
        echo "arch-desktop"
    else
        echo "Anthony"  # Fallback
    fi
}

# Install using Nix
install_with_nix() {
    info "Installing using Nix Home Manager..."

    local host_config=$(get_host_config)
    info "Using host configuration: $host_config"

    if ! has_nix; then
        warning "Nix is not installed. Install it first with:"
        echo "  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
        return 1
    fi

    # Update flake
    info "Updating flake..."
    nix flake update

    # Initial installation
    info "Building and activating configuration..."
    nix run home-manager/master -- switch --flake ".#${host_config}"

    success "Nix installation complete!"
    info "To update in the future, run: home-manager switch --flake .#${host_config}"
}

# Install using Homebrew (macOS)
install_with_homebrew() {
    info "Installing using Homebrew..."

    if ! has_command brew; then
        warning "Homebrew is not installed. Installing now..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install packages from Brewfile
    info "Installing packages from Brewfile..."
    brew bundle install

    # Symlink configs
    info "Symlinking configuration files..."
    if has_command stow; then
        stow .
    else
        warning "GNU Stow not found. Please manually symlink configs or install stow."
    fi

    success "Homebrew installation complete!"
}

# Install using pacman (Arch Linux)
install_with_pacman() {
    info "Installing using pacman..."

    info "Installing packages from packages/pacman.txt..."
    sudo pacman -S --needed - < packages/pacman.txt

    # Symlink configs
    info "Symlinking configuration files..."
    if has_command stow; then
        stow .
    else
        warning "GNU Stow not found. Installing..."
        sudo pacman -S stow
        stow .
    fi

    success "Pacman installation complete!"
    info "Note: Some packages may require AUR (use yay or paru)"
}

# Install using apt (Debian/Ubuntu)
install_with_apt() {
    info "Installing using apt..."

    info "Installing packages from packages/apt.txt..."
    xargs -a packages/apt.txt sudo apt install -y

    # Symlink configs
    info "Symlinking configuration files..."
    if has_command stow; then
        stow .
    else
        warning "GNU Stow not found. Installing..."
        sudo apt install -y stow
        stow .
    fi

    success "Apt installation complete!"
    info "Note: Some packages may need manual installation (eza, zoxide, etc.)"
}

# Install using dnf (Fedora/RHEL)
install_with_dnf() {
    info "Installing using dnf..."

    info "Installing packages from packages/dnf.txt..."
    xargs -a packages/dnf.txt sudo dnf install -y

    # Symlink configs
    info "Symlinking configuration files..."
    if has_command stow; then
        stow .
    else
        warning "GNU Stow not found. Installing..."
        sudo dnf install -y stow
        stow .
    fi

    success "Dnf installation complete!"
    info "Note: Some packages may need COPR or EPEL repositories"
}

# Manual config linking (fallback)
link_configs_manually() {
    info "Symlinking configurations manually..."

    mkdir -p ~/.config

    # Link important configs
    ln -sf "$PWD/.config/nvim" ~/.config/nvim
    ln -sf "$PWD/.config/fish" ~/.config/fish
    ln -sf "$PWD/.config/starship.toml" ~/.config/starship.toml
    ln -sf "$PWD/.config/helix" ~/.config/helix
    ln -sf "$PWD/.config/kitty" ~/.config/kitty
    ln -sf "$PWD/.config/alacritty" ~/.config/alacritty
    ln -sf "$PWD/.config/ghostty" ~/.config/ghostty
    ln -sf "$PWD/.config/zellij" ~/.config/zellij
    ln -sf "$PWD/.config/jj" ~/.config/jj
    ln -sf "$PWD/.config/gh" ~/.config/gh

    # Root level configs
    ln -sf "$PWD/.gitconfig" ~/.gitconfig
    ln -sf "$PWD/.gitignore_global" ~/.gitignore_global
    ln -sf "$PWD/.tmux.conf" ~/.tmux.conf

    success "Configuration files linked!"
}

# Main installation logic
main() {
    echo ""
    info "=== Dotfiles Bootstrap Script ==="
    echo ""

    local os=$(detect_os)
    local arch=$(detect_arch)
    local nix_system=$(get_nix_system)

    info "Detected OS: $os"
    info "Detected Architecture: $arch"
    info "Nix System: $nix_system"
    echo ""

    # Check for Nix first (preferred method)
    if has_nix; then
        info "Nix detected! This is the recommended installation method."
        read -p "Use Nix for installation? [Y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
            install_with_nix
            return 0
        fi
    else
        warning "Nix not found. Falling back to system package manager."
        info "For the best experience, consider installing Nix:"
        info "  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
        echo ""
    fi

    # Fall back to package managers
    case $os in
        macos)
            install_with_homebrew
            ;;
        arch|manjaro|endeavour*)
            install_with_pacman
            ;;
        ubuntu|debian)
            install_with_apt
            ;;
        fedora|rhel|centos)
            install_with_dnf
            ;;
        *)
            error "Unsupported OS: $os"
            warning "Please install packages manually and run:"
            info "  ./scripts/link-configs.sh"
            return 1
            ;;
    esac

    echo ""
    success "Bootstrap complete!"
    info "You may need to log out and back in for shell changes to take effect."
    echo ""
}

# Run main function
main "$@"
