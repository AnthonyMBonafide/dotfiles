# Traditional Installation (Without Nix)

This document covers installing dotfiles **without Nix** using traditional package managers (Homebrew, apt, pacman, etc.).

> **Recommended:** For personal machines where you have full control, use Nix instead. See [README.md](./README.md) for the primary Nix-based setup with declarative, reproducible configuration.

## When to Use This Method

Use traditional installation when:
- You cannot install Nix (work machines, restricted environments)
- You prefer traditional package managers
- You're on a system where Nix is not well-supported
- You need to quickly test the dotfiles

## What You Get

**Configurations included:**
- Fish Shell + Starship + Atuin
- Neovim (LazyVim) with full LSP support
- Git + Jujutsu (jj)
- Tmux, Zellij
- Ghostty, Kitty, Alacritty terminals
- Modern CLI tools (ripgrep, fd, bat, eza, fzf, etc.)
- Development tools (Go, Rust, Docker/Podman, etc.)

## Quick Start

```bash
# Clone repository
git clone git@github.com:AnthonyMBonafide/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run bootstrap script (detects your OS and installs accordingly)
./scripts/bootstrap.sh
```

---

## Installation Methods

### Option 1: Bootstrap Script (Automatic)

The bootstrap script detects your environment and installs using the best available method:

```bash
cd ~/dotfiles
./scripts/bootstrap.sh
```

**What it does:**
1. Detects your OS and architecture
2. Checks for Nix (uses if available)
3. Falls back to system package manager:
   - **macOS** → Homebrew (uses `Brewfile`)
   - **Arch/Manjaro/Endeavor** → pacman
   - **Ubuntu/Debian** → apt
   - **Fedora/RHEL** → dnf
4. Symlinks all configurations

### Option 2: Manual Installation

#### macOS (Homebrew)

```bash
# Install Homebrew if needed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
cd ~/dotfiles
brew bundle install

# Link configurations
stow .
# Or: ./scripts/link-configs.sh
```

#### Arch Linux / Manjaro / Endeavor OS

```bash
# Install packages
cd ~/dotfiles
sudo pacman -S --needed - < packages/pacman.txt

# For AUR packages (lazyjj, etc.)
yay -S lazyjj-git

# Link configurations
stow .
```

#### Ubuntu / Debian

```bash
cd ~/dotfiles
xargs -a packages/apt.txt sudo apt install -y

# Link configurations
stow .
```

See [packages/README.md](./packages/README.md) for more package manager options.

### Option 3: Configuration Files Only

If you need to install packages separately (highly restricted environment):

```bash
cd ~/dotfiles
./scripts/link-configs.sh
```

This only creates symlinks for configuration files without installing any packages.

---

## Installation Decision Tree

```
Use Traditional Package Managers:
├─ Automatic: ./scripts/bootstrap.sh
├─ macOS: brew bundle install && stow .
├─ Arch: sudo pacman -S - < packages/pacman.txt && stow .
├─ Ubuntu: xargs -a packages/apt.txt sudo apt install -y && stow .
└─ Restricted: ./scripts/link-configs.sh (configs only)

For Nix-based installation, see README.md
```

---

## Post-Installation

After installing packages and linking configs:

### Set Fish as Default Shell

```bash
# Add Fish to /etc/shells (if not present)
which fish | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which fish)
```

### Git Setup

```bash
# Generate SSH key (if needed)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Upload to GitHub
# - Add SSH public key for authentication
# - Add SSH public key for signing (yes, add it twice)
# - Configure for SSO/SAML if needed

# Authenticate GitHub CLI
gh auth login

# Create project directories
mkdir -p ~/projects/work ~/projects/oss
```

### Neovim Setup

```bash
# Open Neovim (plugins will auto-install with LazyVim)
nvim

# Run health check
:checkhealth
```

### Podman Setup (macOS)

```bash
# Initialize Podman VM
podman machine init
podman machine start

# If needed, install helper
sudo /opt/homebrew/Cellar/podman/*/bin/podman-mac-helper install
```

### macOS-Specific

- **Caps Lock → Control**: System Settings → Keyboard → Modifier Keys
- **Allow unsigned apps**: System Settings → Privacy & Security (for Ghostty, Alacritty)

---

## Repository Structure

```
dotfiles/
├── README.md              # Nix-based installation (primary)
├── TRADITIONAL-README.md  # This file - traditional installation
├── Brewfile               # Homebrew packages (macOS without Nix)
├── flake.nix              # Nix flake configuration
├── home.nix               # Nix home-manager entry
├── hosts/                 # Host-specific Nix configs
├── modules/               # Nix modules (shell, dev, editors, etc.)
├── packages/              # Package lists for apt/pacman/dnf/winget
├── scripts/               # Installation and helper scripts
│   ├── bootstrap.sh       # Universal installer
│   └── link-configs.sh    # Manual config linking
└── .config/               # Source configuration files
    ├── nvim/              # Neovim (LazyVim)
    ├── fish/              # Fish shell
    ├── starship.toml      # Starship prompt
    ├── helix/             # Helix editor
    ├── kitty/             # Kitty terminal
    ├── alacritty/         # Alacritty terminal
    ├── ghostty/           # Ghostty terminal
    ├── zellij/            # Zellij multiplexer
    └── ...
```

---

## Documentation

- **[README.md](./README.md)** - Primary Nix-based installation (recommended)
- **[packages/README.md](./packages/README.md)** - Package manager lists for traditional installation
- **[scripts/README.md](./scripts/README.md)** - Installation scripts
- **[Claude.md](./Claude.md)** - Context for Claude Code AI

---

## Updating Dotfiles

```bash
cd ~/dotfiles
git pull

# Update packages
brew bundle install  # macOS
# or: sudo pacman -Syu  # Arch
# or: sudo apt upgrade  # Ubuntu

# Relink configs (if changed)
stow .
```

---

## Troubleshooting

### Configs Not Applied

```bash
# Verify symlinks
ls -la ~/.config/nvim
ls -la ~/.config/fish

# Re-run stow
cd ~/dotfiles
stow --restow .
```

### Package Not Found

Check the appropriate package list in `packages/` and install manually or comment out from the list.

### Need Nix Features?

If you find you need the declarative benefits of Nix:
- See [README.md](./README.md) for Nix installation
- Nix can coexist with traditional package managers
- Easy to migrate configs from traditional to Nix setup

---

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt for your own use!
