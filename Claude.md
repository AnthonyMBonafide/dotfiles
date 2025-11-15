# Claude Context File

This document provides context for Claude Code to better assist with this dotfiles repository.

## Project Overview

This is a personal dotfiles repository using **NixOS** and **Nix Home Manager** for declarative, reproducible configuration management. The project prioritizes Nix-based approaches with fallback to traditional package managers for restricted environments.

### Configuration Priority Order
1. **NixOS** (Full system configuration - gaming desktop, servers)
2. **Nix Home Manager** (User configuration on macOS, Linux distributions)
3. **Traditional Package Managers** (Work machines, restricted environments)

### Target Platforms
- **NixOS** (primary - black-mesa gaming desktop with 3 monitors)
- **macOS** (development environment - using Nix Home Manager)
- **Linux** - Arch-based distributions with Nix Home Manager:
  - Arch Linux
  - Manjaro
  - Endeavor OS
- **Traditional** (work/restricted machines without Nix)

### End Goal
Enable quick, consistent setup of any new system with identical configurations using declarative Nix approaches (NixOS for full systems, Home Manager for user environments).

## Current State

### What's Complete

#### NixOS System Configurations
- ✅ **black-mesa** - Gaming desktop with 3 monitors (NVIDIA RTX)
  - Steam, GameMode, GameScope, XWayland
  - Hyprland and Niri window managers (Wayland-native)
  - MangoHud, Goverlay for performance monitoring
  - Dedicated `/mnt/steamgames` mount (ext4, 1TB)
  - NVIDIA proprietary drivers
  - Power management (no hibernation, screensaver + monitor power-off)
- ✅ **nixos** - General development workstation

#### Home Manager
- ✅ Nix flake infrastructure (`flake.nix`, `flake.lock`)
- ✅ Home Manager base configuration (`home.nix`)
- ✅ **Multi-system support** - macOS, Linux, NixOS
- ✅ **Host-specific configurations** in `hosts/` directory
- ✅ **Platform conditionals** in modules
- ✅ Core modules:
  - `modules/shell.nix` - Fish, Starship, Atuin, CLI tools
  - `modules/terminals.nix` - Alacritty, Kitty, Ghostty, Zellij
  - `modules/development.nix` - Git, Go, Rust, databases, dev tools
  - `modules/editors.nix` - Editor configurations
  - `modules/neovim.nix` - Neovim with LazyVim, LSP
  - `modules/packages.nix` - Fonts, applications
  - `modules/hyprland.nix` - Hyprland window manager (Wayland)
  - `modules/niri.nix` - Niri scrollable-tiling compositor (Wayland)
  - `modules/screensaver.nix` - Wayland screensavers (swaylock-effects, cava, pipes-rs)

#### NixOS System Modules
- ✅ `modules/nixos/gaming.nix` - Gaming configuration
  - Steam with GameScope session
  - GameMode with CPU/GPU optimizations
  - XWayland support (services.xserver.enable, xwayland-satellite)
  - MangoHud and Goverlay
  - Steam games storage mount
  - Optional: Proton-GE, Lutris, Heroic, controller tools

### What's In Progress
- 🔄 Testing Niri on additional systems
- 🔄 Optimizing gaming performance settings

### Legacy/Coexisting
- Traditional package manager support (see `TRADITIONAL-README.md`)
- Original config files in `.config/` directory (symlinked by Nix)
- Homebrew for macOS-specific GUI applications
- GNU Stow option for work/restricted machines

## Architecture

```
dotfiles/
├── README.md              # Primary Nix/NixOS documentation
├── TRADITIONAL-README.md  # Traditional installation (Homebrew, apt, pacman)
├── Brewfile               # Homebrew packages (macOS without Nix)
├── flake.nix              # Nix flake with multi-system support
├── home.nix               # Nix home-manager entry point
├── hosts/                 # Host-specific configurations
│   ├── black-mesa/        # NixOS gaming desktop (3 monitors, NVIDIA)
│   │   ├── configuration.nix      # System configuration
│   │   ├── hardware-configuration.nix  # Hardware detection
│   │   └── README.md      # Gaming/Steam documentation
│   ├── black-mesa-home.nix  # Home manager for black-mesa user
│   ├── nixos/             # NixOS general desktop
│   ├── nixos-desktop.nix  # Home manager for nixos user
│   ├── macbook-pro.nix    # macOS configuration
│   └── arch-desktop.nix   # Linux (Arch) configuration
├── modules/               # Home Manager modules
│   ├── shell.nix          # Shell environment (Fish, Starship, CLI tools)
│   ├── terminals.nix      # Terminal emulators
│   ├── development.nix    # Development tools, languages, databases
│   ├── editors.nix        # Text editors and formatters
│   ├── neovim.nix         # Neovim-specific configuration
│   ├── packages.nix       # Fonts, applications, general packages
│   ├── hyprland.nix       # Hyprland window manager (Wayland)
│   ├── niri.nix           # Niri scrollable-tiling compositor (Wayland)
│   ├── screensaver.nix    # Wayland screensavers
│   └── nixos/             # NixOS system modules
│       ├── gaming.nix     # Steam, GameMode, XWayland, gaming setup
│       └── README.md      # NixOS modules documentation
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

### Multi-Level Installation Support
The repository supports **three levels of configuration**:

1. **NixOS** (Recommended for dedicated machines)
   - Full system configuration (services, hardware, users)
   - Window managers (Hyprland, Niri)
   - Gaming setup (Steam, GameMode, XWayland)
   - Home Manager integrated
   - Examples: black-mesa (gaming), nixos (development)

2. **Nix Home Manager** (For macOS or non-NixOS Linux)
   - User-level configuration only
   - Multi-system support via flake
   - Works on macOS, Arch, Manjaro, Endeavor
   - Easy rollback and updates

3. **Traditional Package Managers** (For work/restricted environments)
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

### Gaming Setup (NixOS)
The gaming module (`modules/nixos/gaming.nix`) provides comprehensive gaming support:

**Key Components:**
- **Steam**: Full installation with Proton for Windows games
- **GameScope**: Wayland-native micro-compositor for better gaming performance
- **GameMode**: Automatic CPU/GPU optimization when games run
- **XWayland**: Required for Steam and X11-only games
  - `services.xserver.enable = true` (system-level)
  - `xwayland-satellite` for Niri
  - Built-in XWayland for Hyprland
- **Performance Tools**:
  - MangoHud: FPS/temperature overlay
  - Goverlay: GUI for MangoHud configuration
- **Storage**: Dedicated `/mnt/steamgames` mount point (ext4, nofail)

**Why XWayland Only for Gaming:**
- Steam and most games are X11-only applications
- Native Wayland apps don't need XWayland
- XWayland is isolated to gaming module for clean Wayland-first systems

### Window Managers (Wayland-Native)
Two Wayland compositors are configured:

**Hyprland** (`modules/hyprland.nix`):
- Dynamic tiling window manager
- Built-in XWayland support
- Hypridle for idle management
- Hyprlock for screen locking
- Hyprpaper for wallpapers
- Traditional tiling workflow

**Niri** (`modules/niri.nix`):
- Scrollable-tiling compositor (unique horizontal workspace scrolling)
- Uses xwayland-satellite for XWayland support
- Configuration in KDL (KubeDoc Language) - strict syntax
- Swayidle for idle management
- Natural workflow for multi-monitor setups
- **IMPORTANT**: Always run `niri validate` after config changes

**black-mesa Monitor Setup:**
- 3 monitors configured in Niri (modules/niri.nix:110-151)
- Left: Dell P2419H (1920x1080@60Hz) on DP-3
- Center: Dell AW2521HF (1920x1080@60Hz) on DP-2
- Right: Third monitor (commented - will activate when detected)
- Total horizontal resolution: 5760x1080 (when all connected)

### Multi-System Support
The configuration supports multiple systems and architectures:

**NixOS Systems:**
- **black-mesa**: `sudo nixos-rebuild switch --flake .#black-mesa`
- **nixos**: `sudo nixos-rebuild switch --flake .#nixos`

**Home Manager (non-NixOS):**
- **macOS Apple Silicon**: `home-manager switch --flake .#macbook-pro`
- **macOS Intel**: `home-manager switch --flake .#macbook-intel`
- **Linux x86_64**: `home-manager switch --flake .#arch-desktop`
- **Linux ARM**: `home-manager switch --flake .#arch-arm`

Platform-specific packages are automatically selected based on the system architecture using `pkgs.lib.optionals` and `pkgs.stdenv.isDarwin`/`pkgs.stdenv.isLinux`.

## Working with This Project

### Common Tasks

#### Switching Configurations on Different Systems
```bash
# NixOS systems (requires sudo)
sudo nixos-rebuild switch --flake .#black-mesa  # Gaming desktop
sudo nixos-rebuild switch --flake .#nixos       # Dev workstation

# Home Manager only (macOS, Arch, etc.)
home-manager switch --flake .#macbook-pro   # macOS
home-manager switch --flake .#arch-desktop  # Linux

# First time on a new system
nix run home-manager/master -- switch --flake .#<hostname>
```

#### Adding a New NixOS Host
1. Create host directory: `hosts/my-host/`
2. Generate hardware config: `sudo nixos-generate-config --show-hardware-config > hosts/my-host/hardware-configuration.nix`
3. Create `hosts/my-host/configuration.nix` (see black-mesa as example)
4. Create `hosts/my-host-home.nix` for home-manager config
5. Add to `flake.nix` under `nixosConfigurations`
6. Deploy: `sudo nixos-rebuild switch --flake .#my-host`

#### Adding a New Home Manager Host
1. Create a new file in `hosts/` (e.g., `hosts/my-laptop.nix`)
2. Define `home.username` and `home.homeDirectory`
3. Add host-specific packages if needed
4. Add new entry in `flake.nix` under `homeConfigurations`
5. Deploy: `home-manager switch --flake .#my-laptop`

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

#### Gaming-Specific Tasks (NixOS)

**Adding a game launcher:**
1. Edit `modules/nixos/gaming.nix`
2. Uncomment desired launcher (Lutris, Heroic, Proton-GE)
3. Rebuild: `sudo nixos-rebuild switch --flake .#black-mesa`

**Checking Steam games storage:**
```bash
# Check mount status
df -h /mnt/steamgames

# Verify in Steam
# Settings → Storage → Add library folder: /mnt/steamgames
```

**Testing game performance:**
```bash
# Launch with monitoring
gamemoderun mangohud %command%

# Check GameMode status
gamemoded -s

# Check NVIDIA GPU
nvidia-smi
```

**Troubleshooting XWayland:**
```bash
# Verify XWayland is running (needed for Steam)
ps aux | grep -i xwayland

# Hyprland: Built-in XWayland
# Niri: Should show xwayland-satellite process
```

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
3. **Check README.md** for existing patterns/examples
4. **Consider platform compatibility** - will this work on Linux and macOS?

### What to Avoid
- Don't hardcode absolute paths (use `~` or Nix variables)
- Don't add sensitive information (SSH keys, tokens, etc.)
- Don't force-push or amend commits without explicit approval
- Don't remove XWayland from non-gaming systems (it's only in gaming module)
- Don't skip `niri validate` after Niri config changes
- Don't modify `/mnt/steamgames` mount without user approval (external drive)

### Useful Context

**User Information:**
- Username: "anthony" (lowercase in NixOS/Linux configs)
- Username: "Anthony" (macOS, legacy compatibility)

**Primary Systems:**
- **black-mesa**: NixOS gaming desktop
  - 3 monitors (5760x1080 total resolution)
  - NVIDIA RTX GPU
  - Window managers: Hyprland, Niri (both Wayland)
  - Gaming: Steam, GameMode, GameScope
  - Storage: `/mnt/steamgames` for game library
- **macOS**: Development laptop
  - Home Manager for user config
  - Homebrew for GUI apps

**Workflow & Tools:**
- Shell: Fish + Starship + Atuin
- Editor: Neovim (LazyVim) + Helix
- Terminal: Ghostty (preferred), Alacritty, Kitty
- Multiplexer: Tmux, Zellij
- VCS: Git + Jujutsu (jj)
- Development: Go, Rust, PostgreSQL, Docker/Podman

**Window Managers:**
- Hyprland: Traditional dynamic tiling
- Niri: Scrollable-tiling (preferred for 3-monitor setup)
  - Horizontal workspace scrolling
  - KDL configuration (strict syntax)
  - Validate with `niri validate` after changes

**Gaming Setup:**
- Steam with Proton (Windows games on Linux)
- GameMode for performance optimization
- GameScope for Wayland gaming
- MangoHud/Goverlay for monitoring
- XWayland only for games (not native apps)

## Common Questions

### "Why both README.md and TRADITIONAL-README.md?"
README.md is the primary Nix-based installation (recommended). TRADITIONAL-README.md documents the traditional Stow/Homebrew/apt approach for work machines or environments where Nix cannot be installed.

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

## Project Status Checklist

### Core Infrastructure
- [x] Set up Nix flakes
- [x] Configure home-manager base
- [x] Create multi-system support in flake.nix
- [x] Add host-specific configurations (macOS, Linux)
- [x] Implement platform conditionals in modules

### Home Manager Migration
- [x] Migrate shell configuration (Fish, Starship, Atuin)
- [x] Migrate development tools
- [x] Migrate editor configurations
- [x] Set up Neovim with LazyVim
- [x] Configure rust-analyzer for Neovim
- [x] Hyprland window manager configuration
- [x] Niri window manager configuration
- [x] Wayland-native screensavers

### NixOS Full System
- [x] **NixOS configuration for black-mesa (gaming desktop)**
- [x] **Gaming module (Steam, GameMode, GameScope)**
- [x] **XWayland integration (gaming only)**
- [x] **Power management (no hibernation, screensaver)**
- [x] **3-monitor Niri configuration**
- [x] **NVIDIA driver setup**
- [x] **Dedicated Steam games storage mount**
- [x] **NixOS configuration for nixos (dev workstation)**
- [x] **Comprehensive gaming documentation**

### Documentation
- [x] **Make Nix primary README**
- [x] **Create TRADITIONAL-README for non-Nix**
- [x] **Gaming/Steam documentation**
- [x] **NixOS modules documentation**
- [x] **Update Claude context with NixOS/gaming info**

### Future Work
- [ ] Test on actual Arch Linux hardware (non-NixOS)
- [ ] Test on different Arch variants (Manjaro, Endeavor)
- [ ] Document Windows/WSL compatibility approach
- [ ] Performance tuning for gaming
- [ ] Additional window manager configs (Sway, etc.)

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options Search](https://nix-community.github.io/home-manager/options.html)
- [Nix Package Search](https://search.nixos.org/packages)
- [NixOS Options Search](https://search.nixos.org/options)
- [My Nix README](./README.md)
- [Traditional Installation README](./TRADITIONAL-README.md)
