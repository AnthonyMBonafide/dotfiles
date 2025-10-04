# Nix Home-Manager Dotfiles

This repository now supports **Nix Home-Manager** for declarative system configuration management, in addition to the traditional GNU Stow approach (see main [README.md](./README.md)).

## Structure

```
dotfiles/
├── flake.nix              # Main flake configuration
├── home.nix               # Home-manager entry point
├── .config/               # Original configuration files (referenced by modules)
└── modules/               # Organized configuration modules
    ├── shell.nix          # Fish, Starship, Atuin, CLI tools
    ├── terminals.nix      # Alacritty, Kitty, Ghostty, Zellij
    ├── development.nix    # Git, Go, Databases, Dev tools
    ├── editors.nix        # Neovim, Helix, Linters/Formatters
    ├── system.nix         # Karabiner Elements (macOS)
    └── packages.nix       # Fonts, Applications, General packages
```

## Installation

### Prerequisites

1. **Install Nix** (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Enable Nix Flakes** (should be enabled by default with Determinate Nix Installer)

### Initial Setup

1. Clone this repository (if not already done):
   ```bash
   git clone git@github.com:AnthonyMBonafide/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Initialize the flake:
   ```bash
   nix flake update
   ```

3. Build and activate the configuration:
   ```bash
   nix run home-manager/master -- switch --flake .#Anthony
   ```

### Subsequent Updates

After making changes to your configuration:

```bash
home-manager switch --flake .#Anthony
```

## What's Managed by Nix

### Fully Declarative (via Nix)
- **Shell**: Fish, Starship, Atuin
- **CLI Tools**: bat, eza, fd, ripgrep, fzf, jq, yq, zoxide, lazygit, lazyjj, and more
- **Development**: Git, Go, GCC, PostgreSQL, Docker/Podman tools, Go tooling
- **Editors**: Neovim (config symlinked), Helix
- **Terminals**: Alacritty, Kitty, Zellij (configs referenced)
- **Fonts**: Hack Nerd Font, JetBrains Mono, Ubuntu Nerd Font
- **Tools**: tmux, stow, wget, watchexec, task, tldr, gnupg

### Referenced Configurations (Symlinked)
The following configurations are kept in `.config/` and symlinked by Nix:
- Neovim (LazyVim setup preserved)
- Starship (TOML config)
- Helix (TOML configs)
- Jujutsu (TOML config)
- Terminal configs (Ghostty, Zellij KDL, Kitty)
- Karabiner Elements (JSON)
- GitHub CLI (YAML)

## Still Using Homebrew

Some macOS-specific applications are better installed via Homebrew casks:

```bash
# Install Homebrew if needed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install macOS-specific applications
brew install --cask \
  bruno \
  keepassxc \
  meetingbar \
  scroll-reverser \
  spotify \
  ghostty
```

## Package Inventory

### Shell & CLI Tools (modules/shell.nix)
- **Modern CLI replacements**: bat, eza, fd, ripgrep, lsd, zoxide
- **Search & navigation**: fzf, tldr
- **File monitoring**: watchexec
- **Data processing**: jq, yq
- **Download tools**: wget
- **Task management**: taskwarrior
- **Git tools**: lazygit, lazyjj
- **Other**: zsh, tmux, stow, gnupg, pinentry_mac, zls

### Development Tools (modules/development.nix)
- **Languages**: gcc, go
- **Go tools**: go-swagger, golang-migrate, golangci-lint
- **Databases**: postgresql_14, pgcli
- **Container tools**: docker-completion, podman-compose
- **Kafka**: kcat
- **Documentation**: adr-tools
- **Virtualization**: qemu
- **VCS**: git, jujutsu (jj), gh (GitHub CLI)

### Editors & Writing (modules/editors.nix)
- **Editors**: neovim, helix
- **Lua**: luarocks
- **Linters/Formatters**: markdownlint-cli, prettier, sqlfluff

### Terminals (modules/terminals.nix)
- alacritty, kitty, zellij
- ghostty (via Homebrew recommended)

### Applications & Fonts (modules/packages.nix)
- **AI/ML**: ollama
- **Browsers**: firefox
- **Fonts**: Hack Nerd Font, JetBrains Mono, Ubuntu Nerd Font

## Package Notes

### Potentially Unavailable in Nixpkgs
Some packages might not be available or have different names in nixpkgs:
- `bruno` - API client (may need Homebrew)
- `ghostty` - Terminal emulator (may need Homebrew until in nixpkgs)
- `markdown-toc` - May need npm installation

If a package fails to build, comment it out in the relevant module and install via Homebrew:
```bash
brew install <package-name>
```

## Customization

### Adding New Packages
Add packages to the appropriate module in `modules/`:
- CLI tools → `modules/shell.nix`
- Development tools → `modules/development.nix`
- Editor plugins/tools → `modules/editors.nix`
- GUI apps/fonts → `modules/packages.nix`

### Modifying Configurations
1. Edit the configuration files in `.config/`
2. Run `home-manager switch --flake .#Anthony` to apply changes
3. Nix will re-symlink the updated configurations

### Adding Fish Aliases
You can add Fish aliases in `modules/shell.nix` under `programs.fish.shellAliases`:
```nix
shellAliases = {
  ll = "ls -la";
  gs = "git status";
};
```

Or continue using separate alias files in `.config/fish/` and uncomment the source lines in `modules/shell.nix`.

## Troubleshooting

### Build Fails
If the build fails due to a missing package:
1. Check the error message to identify which package is missing
2. Comment out the failing package in the module
3. Run `home-manager switch --flake .#Anthony` again
4. Install the package manually via Homebrew if needed

### Permission Issues
If you encounter permission issues with symlinks:
```bash
# Backup existing configs
mv ~/.config/nvim ~/.config/nvim.backup

# Try again
home-manager switch --flake .#Anthony
```

### Updating Packages
To update all packages to the latest versions:
```bash
nix flake update
home-manager switch --flake .#Anthony
```

### Garbage Collection
To clean up old generations and free disk space:
```bash
# Remove old generations
home-manager expire-generations "-7 days"

# Run garbage collection
nix-collect-garbage -d
```

## Migration from Homebrew

This configuration was converted from Homebrew-managed dotfiles. The original Homebrew package lists are preserved in:
- `scripts/brew-list.txt`
- `scripts/brew-casks-list.txt`
- `scripts/additional-brew-list.txt`

Most packages have been migrated to Nix, but some macOS-specific GUI applications remain on Homebrew for better system integration.

## Advantages of Nix Home-Manager

- **Declarative**: Your entire system configuration is described in code
- **Reproducible**: Easy to recreate your setup on new machines
- **Atomic**: Updates are all-or-nothing, with easy rollback
- **Version Control**: All configuration changes are tracked in git
- **Isolated**: Packages don't conflict with system installations
- **Cross-platform**: Same configuration can work on Linux and macOS

## Traditional Stow Setup

If you prefer the traditional GNU Stow approach, see the main [README.md](./README.md) for instructions.

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Nix Package Search](https://search.nixos.org/packages)
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Learn Nix concepts
