#!/usr/bin/env bash

# Simple script to symlink configuration files
# Use this when Stow is not available or you want manual control

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

info "Dotfiles directory: $DOTFILES_DIR"
info "Creating symlinks..."

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Link config directories
link_if_not_exists() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        info "Backing up existing $dest to ${dest}.backup"
        mv "$dest" "${dest}.backup"
    fi

    if [ -L "$dest" ]; then
        info "Removing existing symlink: $dest"
        rm "$dest"
    fi

    ln -sf "$src" "$dest"
    success "Linked: $src -> $dest"
}

# Neovim
link_if_not_exists "$DOTFILES_DIR/.config/nvim" ~/.config/nvim

# Fish shell
link_if_not_exists "$DOTFILES_DIR/.config/fish" ~/.config/fish

# Starship prompt
link_if_not_exists "$DOTFILES_DIR/.config/starship.toml" ~/.config/starship.toml

# Helix editor
link_if_not_exists "$DOTFILES_DIR/.config/helix" ~/.config/helix

# Terminals
link_if_not_exists "$DOTFILES_DIR/.config/kitty" ~/.config/kitty
link_if_not_exists "$DOTFILES_DIR/.config/alacritty" ~/.config/alacritty
link_if_not_exists "$DOTFILES_DIR/.config/ghostty" ~/.config/ghostty
link_if_not_exists "$DOTFILES_DIR/.config/zellij" ~/.config/zellij

# Version control
link_if_not_exists "$DOTFILES_DIR/.config/jj" ~/.config/jj
link_if_not_exists "$DOTFILES_DIR/.config/gh" ~/.config/gh

# Karabiner (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    link_if_not_exists "$DOTFILES_DIR/.config/karabiner" ~/.config/karabiner
fi

# Root level configs
link_if_not_exists "$DOTFILES_DIR/.gitconfig" ~/.gitconfig
link_if_not_exists "$DOTFILES_DIR/.gitignore_global" ~/.gitignore_global
link_if_not_exists "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf

echo ""
success "All configurations linked successfully!"
info "You may need to restart your terminal or shell for changes to take effect."
