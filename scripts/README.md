# Installation Scripts

Helper scripts for setting up dotfiles in different environments.

## bootstrap.sh

**Universal installation script** that detects your environment and uses the best available method.

### Usage

```bash
cd ~/dotfiles
./scripts/bootstrap.sh
```

### What it does

1. **Detects OS and architecture** (macOS/Linux, ARM/x86)
2. **Checks for Nix** - Uses Nix Home Manager if available (recommended)
3. **Falls back to system package manager**:
   - macOS → Homebrew
   - Arch/Manjaro/Endeavor → pacman
   - Ubuntu/Debian → apt
   - Fedora/RHEL → dnf
4. **Symlinks configurations** using Stow or manual linking

### When to use

- First time setup on a new machine
- Switching between Nix and non-Nix environments
- Automated setup in CI/CD or provisioning scripts

## link-configs.sh

**Manual configuration linking** without package installation.

### Usage

```bash
cd ~/dotfiles
./scripts/link-configs.sh
```

### What it does

Creates symlinks for all configuration files from `~/dotfiles/.config/` to `~/.config/`.

### When to use

- When you only want to link configs, not install packages
- When Stow is not available
- When you have custom package installation needs
- On restricted systems where you install packages separately

## Installation Decision Tree

```
Do you have Nix?
├─ Yes
│  └─ Run: nix run home-manager/master -- switch --flake .#<host>
│
└─ No → Can you install Nix?
   ├─ Yes
   │  └─ Install Nix, then use home-manager
   │
   └─ No → Run: ./scripts/bootstrap.sh
      │
      ├─ macOS → Uses Homebrew (Brewfile)
      ├─ Arch → Uses pacman (packages/pacman.txt)
      ├─ Ubuntu/Debian → Uses apt (packages/apt.txt)
      ├─ Fedora/RHEL → Uses dnf (packages/dnf.txt)
      └─ Other → Manual installation + ./scripts/link-configs.sh
```

## Examples

### Example 1: New Personal Mac (Nix Allowed)

```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone dotfiles
git clone git@github.com:AnthonyMBonafide/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Use Nix (recommended)
nix run home-manager/master -- switch --flake .#macbook-pro
```

### Example 2: Work Mac (Nix Not Allowed)

```bash
# Clone dotfiles
git clone git@github.com:AnthonyMBonafide/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install Homebrew (if not present)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Use bootstrap script
./scripts/bootstrap.sh

# Or manually
brew bundle install
stow .
```

### Example 3: Arch Linux Desktop

```bash
# Clone dotfiles
git clone git@github.com:AnthonyMBonafide/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Option A: Use Nix (recommended)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix run home-manager/master -- switch --flake .#arch-desktop

# Option B: Use pacman
./scripts/bootstrap.sh
```

### Example 4: Highly Restricted Environment

```bash
# Clone dotfiles
git clone git@github.com:AnthonyMBonafide/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install packages manually (via IT, package manager, or binaries)
# ... install neovim, fish, ripgrep, etc.

# Link configurations only
./scripts/link-configs.sh
```

## Troubleshooting

### "Permission denied" when running scripts

```bash
chmod +x scripts/*.sh
```

### "Command not found: stow"

Install GNU Stow:
- macOS: `brew install stow`
- Arch: `sudo pacman -S stow`
- Ubuntu: `sudo apt install stow`

Or use `./scripts/link-configs.sh` instead.

### Nix installation fails on corporate machine

Use the non-Nix method:
```bash
./scripts/bootstrap.sh
```

This will detect your package manager and install traditionally.

### Some packages are missing

Check the `packages/` directory for your platform and install missing packages manually. Some tools (like eza, zoxide, atuin) may need:
- Cargo: `cargo install <package>`
- Release page downloads
- AUR (for Arch): `yay -S <package>`
