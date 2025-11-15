# Claude Context File

This document provides context for Claude Code to better assist with this dotfiles repository.

## Project Overview

This is a personal dotfiles repository in active migration from **GNU Stow** to **Nix Home Manager**. The goal is declarative, reproducible configuration management across multiple platforms and systems.

### Target Platforms
- **macOS** (primary development environment, currently in use)
- **Linux** - Arch-based distributions:
  - Omarchy
  - Manjaro
  - Endeavor OS
- **Windows** (future consideration)

### End Goal
Enable quick, consistent setup of any new system with identical configurations using a single declarative approach via Nix Home Manager.

## Current State

### What's Complete
- ✅ Nix flake infrastructure (`flake.nix`, `flake.lock`)
- ✅ Home Manager base configuration (`home.nix`)
- ✅ **Multi-system support** - Cross-platform configurations for macOS and Linux
- ✅ **Host-specific configurations** in `hosts/` directory
- ✅ **Platform conditionals** in modules (macOS vs Linux packages)
- ✅ Core modules:
  - `modules/shell.nix` - Fish, Starship, Atuin, CLI tools (with platform detection)
  - `modules/terminals.nix` - Alacritty, Kitty, Ghostty, Zellij
  - `modules/development.nix` - Git, Go, Rust, databases, dev tools
  - `modules/editors.nix` - Editor configurations
  - `modules/neovim.nix` - Neovim with LazyVim setup, rust-analyzer configured
  - `modules/packages.nix` - Fonts, applications, general packages

### What's In Progress
- 🔄 Testing on actual Linux systems (Arch/Manjaro/Endeavor)
- 🔄 Testing full migration from Stow to Nix

### Legacy/Coexisting
- GNU Stow setup still exists (see `README.md`)
- Original config files in `.config/` directory (some symlinked by Nix)
- Homebrew for macOS-specific GUI applications

## Architecture

```
dotfiles/
├── README.md              # Main installation guide (Nix + traditional)
├── NIX-README.md          # Detailed Nix Home Manager documentation
├── Brewfile               # Homebrew packages (macOS without Nix)
├── flake.nix              # Nix flake with multi-system support
├── home.nix               # Nix home-manager entry point
├── hosts/                 # Host-specific Nix configurations
│   ├── macbook-pro.nix    # macOS configuration
│   └── arch-desktop.nix   # Linux (Arch) configuration
├── modules/               # Nix modules (organized by category)
│   ├── shell.nix          # Shell environment (Fish, Starship, CLI tools)
│   ├── terminals.nix      # Terminal emulators
│   ├── development.nix    # Development tools, languages, databases
│   ├── editors.nix        # Text editors and formatters
│   ├── neovim.nix         # Neovim-specific configuration
│   └── packages.nix       # Fonts, applications, general packages
├── packages/              # Package lists for non-Nix installations
│   ├── apt.txt            # Debian/Ubuntu packages
│   ├── pacman.txt         # Arch/Manjaro/Endeavor packages
│   ├── dnf.txt            # Fedora/RHEL packages
│   ├── winget.txt         # Windows packages
│   └── README.md          # Package list documentation
├── scripts/               # Installation and helper scripts
│   ├── bootstrap.sh       # Universal installer (detects OS)
│   ├── link-configs.sh    # Manual config symlinking
│   └── README.md          # Script documentation
├── .config/               # Source configuration files (works with/without Nix)
│   ├── nvim/              # Neovim LazyVim configuration
│   ├── fish/              # Fish shell configs
│   ├── starship.toml      # Starship prompt
│   ├── helix/             # Helix editor
│   ├── jujutsu/           # JJ version control
│   ├── ghostty/           # Ghostty terminal
│   ├── zellij/            # Zellij terminal multiplexer
│   ├── kitty/             # Kitty terminal
│   ├── karabiner/         # Karabiner Elements (macOS)
│   └── gh/                # GitHub CLI
└── Root-level configs:
    ├── .gitconfig         # Git configuration
    ├── .gitignore_global  # Global gitignore
    └── .tmux.conf         # Tmux configuration
```

## Key Design Decisions

### Dual Installation Support
The repository supports **both Nix and traditional package managers**:

1. **Nix Home Manager** (Recommended for personal machines)
   - Fully declarative and reproducible
   - Multi-system support via flake
   - Easy rollback and updates

2. **Traditional Package Managers** (For work/restricted environments)
   - Brewfile for macOS (Homebrew)
   - Package lists for Linux (apt, pacman, dnf)
   - Bootstrap script auto-detects OS
   - Stow or manual symlinking for configs

### Hybrid Approach
1. **Nix-managed packages**: All CLI tools, development tools, fonts (when using Nix)
2. **Symlinked configs**: Complex configs (LazyVim, Starship) kept in `.config/` - work with or without Nix
3. **Homebrew/System packages**: When Nix not available (work machines)

### Why Symlinks for Some Configs?
- LazyVim has its own plugin manager and update mechanism
- Preserves ability to use configs with or without Nix
- Easier to test changes without rebuilding Nix

### Module Organization
Each module is self-contained and can be commented out in `home.nix` if needed for debugging or platform-specific builds.

### Multi-System Support
The configuration now supports multiple systems and architectures:
- **macOS Apple Silicon**: `home-manager switch --flake .#macbook-pro`
- **macOS Intel**: `home-manager switch --flake .#macbook-intel`
- **Linux x86_64**: `home-manager switch --flake .#arch-desktop`
- **Linux ARM**: `home-manager switch --flake .#arch-arm`
- **Legacy (backward compatible)**: `home-manager switch --flake .#Anthony`

Platform-specific packages are automatically selected based on the system architecture using `pkgs.lib.optionals` and `pkgs.stdenv.isDarwin`/`pkgs.stdenv.isLinux`.

## Working with This Project

### Common Tasks

#### Switching Configurations on Different Systems
```bash
# On macOS (current system)
home-manager switch --flake .#macbook-pro

# On Linux (Arch/Manjaro/Endeavor)
home-manager switch --flake .#arch-desktop

# First time on a new system
nix run home-manager/master -- switch --flake .#<hostname>
```

#### Adding a New Host Configuration
1. Create a new file in `hosts/` (e.g., `hosts/my-laptop.nix`)
2. Define `home.username` and `home.homeDirectory`
3. Add host-specific packages if needed
4. Add new entry in `flake.nix` under `homeConfigurations`

#### Adding a New Package
1. Identify the right module:
   - CLI tool → `modules/shell.nix`
   - Dev tool/language → `modules/development.nix`
   - Editor/formatter → `modules/editors.nix`
   - GUI app/font → `modules/packages.nix`
2. Add package to `home.packages` list
3. For platform-specific packages, use:
   ```nix
   ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
     # macOS only
   ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
     # Linux only
   ];
   ```
4. Test with: `home-manager switch --flake .#<hostname>`

#### Adding a New Configuration
1. If it's a program with home-manager module: Configure in appropriate module file using `programs.<name>.*`
2. If it's a custom config: Add to `.config/` and symlink via `home.file` or `xdg.configFile`

#### Modifying Existing Configs
1. Edit files in `.config/` directory or module files
2. Run: `home-manager switch --flake .#<hostname>`
3. Nix will re-symlink updated configurations

#### Working with Non-Nix Installations (Work Machines)

**Installing on a work machine:**
```bash
# Option 1: Automatic (recommended)
./scripts/bootstrap.sh

# Option 2: Manual (macOS with Homebrew)
brew bundle install
stow .

# Option 3: Configs only
./scripts/link-configs.sh
```

**Adding a package (non-Nix):**
1. Add to `Brewfile` (macOS) or appropriate `packages/*.txt` file
2. Install manually: `brew install <pkg>` or `sudo pacman -S <pkg>`
3. Update bootstrap script if it's a common package

**Philosophy:** The `.config/` directory is the source of truth. Packages can be installed via Nix OR traditional package managers, but configs work either way.

#### Testing Changes
```bash
# Update flake inputs
nix flake update

# Switch to new configuration
home-manager switch --flake .#Anthony

# If something breaks, rollback
home-manager generations  # List generations
home-manager switch --switch-generation <number>
```

### Platform Considerations

#### macOS Specific
- Karabiner Elements for key remapping
- Some apps better via Homebrew (Ghostty, Bruno, KeePassXC)
- `pinentry_mac` for GPG

#### Linux Specific
- May need different terminal/font rendering
- SystemD integration options
- Different path handling

#### Cross-Platform
- Use `pkgs.stdenv.isDarwin` or `pkgs.stdenv.isLinux` for platform-specific logic
- Keep platform-specific configs in separate sections or modules
- Test on each platform before committing

## Guidelines for Claude

### When Modifying Nix Files
1. **Always read the file first** before editing
2. **Preserve existing structure** - keep modules organized
3. **Use comments** to explain non-obvious choices
4. **Test assumptions** - check if packages exist in nixpkgs before adding
5. **Maintain consistency** - follow existing naming/organization patterns

### When Modifying Niri Configuration
1. **Always validate changes** - Run `niri validate` after modifying `modules/niri.nix`
2. **Check config syntax** - Niri uses KDL (KubeDoc Language) which has strict syntax requirements
3. **Test before committing** - Invalid Niri configs can prevent the window manager from starting
4. **Validation command**: `niri validate` (checks default location) or `niri validate -c <path>` for custom config path

### When Adding Configuration
1. **Prefer editing existing files** over creating new ones
2. **Don't create documentation files** unless explicitly requested
3. **Check NIX-README.md** for existing patterns/examples
4. **Consider platform compatibility** - will this work on Linux and macOS?

### What to Avoid
- Don't remove the Stow setup yet (migration in progress)
- Don't hardcode absolute paths (use `~` or Nix variables)
- Don't add sensitive information (SSH keys, tokens, etc.)
- Don't force-push or amend commits without explicit approval

### Useful Context
- The user is "Anthony" (username in flake configs)
- Primary workflow: Fish + Starship + Neovim + Tmux
- VCS: Git and Jujutsu (jj)
- Development: Go, PostgreSQL, Docker/Podman
- Terminals: Ghostty (preferred), Alacritty, Kitty, Zellij

## Common Questions

### "Why both README.md and NIX-README.md?"
Migration in progress. README.md documents the old Stow approach, NIX-README.md documents the new Nix approach. Eventually Nix will be primary.

### "Why is `.config/` still here?"
Source of truth for configuration files. Nix symlinks these rather than generating them, preserving the ability to use them outside Nix and making LazyVim plugin management easier.

### "Can I add packages without Nix?"
Yes, Homebrew still works for macOS apps. For CLI tools, prefer adding to Nix modules for reproducibility.

### "How do I handle platform-specific packages?"
Use conditional logic in Nix:
```nix
home.packages = with pkgs; [
  # Cross-platform
  ripgrep
  fd
] ++ lib.optionals stdenv.isDarwin [
  # macOS only
  pinentry_mac
] ++ lib.optionals stdenv.isLinux [
  # Linux only
  xclip
];
```

## Migration Checklist

- [x] Set up Nix flakes
- [x] Configure home-manager base
- [x] Migrate shell configuration (Fish, Starship, Atuin)
- [x] Migrate development tools
- [x] Migrate editor configurations
- [x] Set up Neovim with LazyVim
- [x] Configure rust-analyzer for Neovim
- [x] **Create multi-system support in flake.nix**
- [x] **Add host-specific configurations (macOS, Linux)**
- [x] **Implement platform conditionals in modules**
- [ ] Test on actual Arch Linux hardware
- [ ] Test on different Arch variants (Manjaro, Endeavor)
- [ ] Document Windows/WSL compatibility approach
- [ ] Full switch from Stow to Nix
- [ ] Archive/remove Stow documentation

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options Search](https://nix-community.github.io/home-manager/options.html)
- [Nix Package Search](https://search.nixos.org/packages)
- [My Nix README](./NIX-README.md)
- [Original Stow README](./README.md)
