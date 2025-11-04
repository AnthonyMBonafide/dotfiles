# Package Lists for Non-Nix Installations

This directory contains package lists for various package managers when Nix is not available or not permitted.

## Usage by Platform

### macOS (Homebrew)
Use the `Brewfile` in the root directory:
```bash
cd ~/dotfiles
brew bundle install
```

### Arch Linux / Manjaro / Endeavor OS
```bash
cd ~/dotfiles
sudo pacman -S --needed - < packages/pacman.txt
```

For AUR packages (lazyjj, etc.):
```bash
yay -S lazyjj-git
```

### Ubuntu / Debian
```bash
cd ~/dotfiles
xargs -a packages/apt.txt sudo apt install -y
```

Note: Some packages need manual installation (eza, zoxide, atuin, etc.)

### Fedora / RHEL
```bash
cd ~/dotfiles
xargs -a packages/dnf.txt sudo dnf install -y
```

May need COPR or EPEL repositories enabled.

### Windows (winget)
```powershell
cd ~/dotfiles
Get-Content packages/winget.txt | ForEach-Object { winget install -e --id $_ }
```

For WSL, use the Linux package list (apt.txt for Ubuntu-based WSL).

## What's Not Included

Some tools need to be installed separately:

- **Nerd Fonts**: Download from https://www.nerdfonts.com/
- **eza**: Often needs cargo or manual installation
- **zoxide**: `cargo install zoxide`
- **atuin**: `cargo install atuin` or from releases
- **lazygit**: From releases page or language package manager
- **lazyjj**: Build from source or use cargo

## After Installing Packages

1. **Symlink configurations** using GNU Stow:
   ```bash
   cd ~/dotfiles
   stow .
   ```

2. **Or manually symlink** (if stow not available):
   ```bash
   ln -s ~/dotfiles/.config/nvim ~/.config/nvim
   ln -s ~/dotfiles/.config/fish ~/.config/fish
   ln -s ~/dotfiles/.config/starship.toml ~/.config/starship.toml
   # etc.
   ```

3. **Set Fish as default shell** (if desired):
   ```bash
   # Add fish to /etc/shells if not present
   which fish | sudo tee -a /etc/shells

   # Change default shell
   chsh -s $(which fish)
   ```

## Comparison: Nix vs Traditional Package Managers

| Feature | Nix | Homebrew/apt/pacman |
|---------|-----|---------------------|
| Declarative | ✅ | ❌ (except Brewfile) |
| Reproducible | ✅ | ⚠️ Partial |
| Rollback | ✅ | ❌ |
| Multi-version | ✅ | ❌ |
| Cross-platform | ✅ | ⚠️ Limited |
| Corporate friendly | ❌ Often blocked | ✅ Usually allowed |

Choose the approach that works best for your environment!
