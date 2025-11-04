# Homebrew Bundle for macOS (without Nix)
# Install with: brew bundle install

# Taps
tap "homebrew/bundle"
tap "homebrew/cask"

# ============================================================================
# Shell & CLI Tools (from modules/shell.nix)
# ============================================================================

# Modern CLI replacements
brew "bat"           # Better cat
brew "eza"           # Better ls
brew "fd"            # Better find
brew "ripgrep"       # Better grep
brew "lsd"           # LSDeluxe

# Search and navigation
brew "fzf"           # Fuzzy finder
brew "tldr"          # Simplified man pages
brew "zoxide"        # Smart cd

# File monitoring and execution
brew "watchexec"     # Execute commands on file changes

# Data processing
brew "jq"            # JSON processor
brew "yq"            # YAML processor

# Download tools
brew "wget"

# Task management
brew "taskwarrior-tui"  # Task/todo manager

# Git tools
brew "lazygit"       # Terminal UI for git
brew "lazyjj"        # Terminal UI for jj

# Terminal multiplexer
brew "tmux"

# GNU utilities
brew "gnupg"
brew "pinentry-mac"

# Zig language server
brew "zls"

# ============================================================================
# Development Tools (from modules/development.nix)
# ============================================================================

# Languages & Compilers
brew "gcc"
brew "go"
brew "rust-analyzer"

# Go tools
brew "golangci-lint"

# Container tools
brew "podman"

# Kafka tools
brew "kcat"

# Virtualization
brew "qemu"

# Version Control
brew "git"
brew "jujutsu"       # jj
brew "gh"            # GitHub CLI

# AI Development
cask "claude"        # Claude Code (if available as cask)

# ============================================================================
# Editors (from modules/editors.nix and modules/neovim.nix)
# ============================================================================

brew "neovim"
brew "helix"

# Linters/Formatters
brew "markdownlint-cli"
brew "prettier"
brew "sqlfluff"

# Lua
brew "luarocks"

# Additional LSP/tools for Neovim
brew "tree-sitter"
brew "nixd"          # Nix LSP (if available, otherwise skip)
brew "alejandra"     # Nix formatter
brew "statix"        # Nix linter
brew "lldb"          # Debug adapter

# ============================================================================
# Terminals (from modules/terminals.nix)
# ============================================================================

cask "alacritty"
cask "kitty"
brew "zellij"
cask "ghostty"

# ============================================================================
# Shell (Fish, Starship, Atuin)
# ============================================================================

brew "fish"
brew "starship"
brew "atuin"

# ============================================================================
# Fonts (from modules/packages.nix)
# ============================================================================

cask "font-hack-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-ubuntu-nerd-font"

# ============================================================================
# Applications (macOS GUI apps)
# ============================================================================

cask "firefox"
cask "bruno"         # API client
cask "keepassxc"     # Password manager
cask "spotify"

# Optional: macOS-specific tools
# brew "stow"        # GNU Stow for symlinking (alternative to Nix)

# ============================================================================
# Notes:
# ============================================================================
# - Some packages may not be available in Homebrew (e.g., nixd, alejandra)
# - If a package fails, comment it out and install manually
# - For GUI applications, some are better installed directly from websites
# - Claude Code may need to be installed via: brew install --cask claude-code
