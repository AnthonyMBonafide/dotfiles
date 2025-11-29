# dotfiles

Personal collection of dotfiles for consistent development environment across multiple systems using **Nix Home-Manager** and **NixOS**.

> **Note:** This repository primarily uses Nix for declarative configuration management. If you cannot use Nix (work/restricted machines), see [TRADITIONAL-README.md](./TRADITIONAL-README.md) for Homebrew/apt/pacman installation.

## Structure

```
dotfiles/
├── flake.nix              # Main flake configuration (multi-system support)
├── home.nix               # Home-manager entry point
├── hosts/                 # Host-specific configurations
│   ├── macbook-pro.nix    # macOS configuration
│   └── arch-desktop.nix   # Linux (Arch) configuration
├── .config/               # Original configuration files (referenced by modules)
└── modules/               # Organized configuration modules
    ├── shell.nix          # Fish, Starship, Atuin, CLI tools (with platform detection)
    ├── terminals.nix      # Alacritty, Kitty, Ghostty, Zellij
    ├── development.nix    # Git, Go, Rust, Databases, Dev tools
    ├── editors.nix        # Helix, Linters/Formatters
    ├── neovim.nix         # Neovim/LazyVim configuration
    └── packages.nix       # Fonts, Applications, General packages
```

## Installation

### Prerequisites

1. **Install Nix** (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Enable Nix Flakes** (should be enabled by default with Determinate Nix Installer).

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

3. Build and activate the configuration for your system:

   **On macOS (Apple Silicon):**
   ```bash
   nix run home-manager/master -- switch --flake .#macbook-pro
   ```

   **On macOS (Intel):**
   ```bash
   nix run home-manager/master -- switch --flake .#macbook-intel
   ```

   **On Linux (Arch/Manjaro/Endeavor - x86_64):**
   ```bash
   nix run home-manager/master -- switch --flake .#arch-desktop
   ```

   **On Linux (ARM):**
   ```bash
   nix run home-manager/master -- switch --flake .#arch-arm
   ```

### Subsequent Updates

After making changes to your configuration:

**On macOS:**
```bash
home-manager switch --flake .#macbook-pro
# or use the Fish alias: hms
```

**On Linux:**
```bash
home-manager switch --flake .#arch-desktop
```

**Legacy (backward compatible):**
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
- **Other**: tmux, stow, gnupg, zls
- **Platform-specific**: pinentry_mac (macOS), pinentry-curses (Linux)

### Development Tools (modules/development.nix)
- **Languages**: gcc, go, rust-analyzer
- **Go tools**: golangci-lint
- **Databases**: podman-compose
- **Kafka**: kcat
- **Container tools**: podman-compose
- **Virtualization**: qemu
- **VCS**: git, jujutsu (jj), gh (GitHub CLI)
- **AI Tools**: claude-code

### Editors & Writing
- **Neovim** (modules/neovim.nix): LazyVim configuration with LSP support
  - Configured language servers: rust-analyzer, nixd, gopls, and more
  - Custom plugins: copilot, lazyjj, kulala, mini.files, and more
  - Full Rust, Go, Nix, Markdown support
- **Helix** (modules/editors.nix): Modern modal editor
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

## Multi-System Support

This configuration supports multiple operating systems and architectures using Nix flakes and host-specific configurations.

### Available Configurations

| Configuration    | System          | Use Case                           |
|------------------|-----------------|-------------------------------------|
| `macbook-pro`    | aarch64-darwin  | macOS on Apple Silicon (M1/M2/M3)  |
| `macbook-intel`  | x86_64-darwin   | macOS on Intel processors           |
| `arch-desktop`   | x86_64-linux    | Arch/Manjaro/Endeavor on x86_64     |
| `arch-arm`       | aarch64-linux   | Arch Linux on ARM (Raspberry Pi, etc.) |
| `Anthony`        | aarch64-darwin  | Legacy alias (backward compatible)  |

### Platform-Specific Packages

The configuration automatically selects platform-specific packages using Nix conditionals:

```nix
home.packages = with pkgs; [
  # Cross-platform packages
  ripgrep
  fd
  bat
] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
  # macOS-only packages
  pinentry_mac
] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
  # Linux-only packages
  pinentry-curses
  xclip
];
```

### Adding a New System Configuration

To add a new system (e.g., a work laptop or desktop):

1. **Create a host configuration file** in `hosts/`:
   ```bash
   # Example: hosts/work-laptop.nix
   ```

2. **Define the host-specific settings**:
   ```nix
   { config, pkgs, ... }:

   {
     # System information
     home.username = "anthony";  # Your username on this system
     home.homeDirectory = "/home/anthony";  # Or /Users/Anthony for macOS

     # Host-specific packages (optional)
     home.packages = with pkgs; [
       # Add any packages unique to this system
     ];
   }
   ```

3. **Add the configuration to `flake.nix`**:
   ```nix
   homeConfigurations = {
     # ... existing configurations ...

     "work-laptop" = mkHomeConfiguration {
       system = "x86_64-linux";  # or aarch64-darwin for macOS
       hostModule = ./hosts/work-laptop.nix;
     };
   };
   ```

4. **Activate on the new system**:
   ```bash
   cd ~/dotfiles
   nix run home-manager/master -- switch --flake .#work-laptop
   ```

5. **Update the Fish alias** in `modules/shell.nix` for convenience:
   ```nix
   hms = "home-manager switch --flake .#work-laptop";
   ```

### Supported Architectures

- **macOS**: `aarch64-darwin` (Apple Silicon), `x86_64-darwin` (Intel)
- **Linux**: `x86_64-linux` (AMD/Intel 64-bit), `aarch64-linux` (ARM 64-bit)

### Windows/WSL Support

For Windows Subsystem for Linux (WSL), use the Linux configurations:
- WSL runs as `x86_64-linux`
- Use `arch-desktop` or create a WSL-specific host config
- Note: Some GUI features may be limited in WSL

## NixOS System Configurations

In addition to Home Manager, this repository includes full NixOS system configurations for dedicated machines.

### Available NixOS Hosts

| Host        | Purpose             | Special Features                          |
|-------------|---------------------|-------------------------------------------|
| `black-mesa`| Gaming Desktop      | Steam, NVIDIA, GameMode, Hyprland, Niri   |
| `nixos`     | General Desktop     | Development workstation                   |

### Installing NixOS Configuration

For NixOS systems, deploy the full system configuration:

```bash
cd ~/dotfiles

# Deploy to black-mesa gaming system
sudo nixos-rebuild switch --flake .#black-mesa

# Deploy to general nixos system
sudo nixos-rebuild switch --flake .#nixos
```

This will configure:
- System services and hardware
- Window managers and desktop environment
- Home Manager for user configuration
- Host-specific features (gaming, development, etc.)

### NixOS Modules

System-level modules are in `modules/nixos/`:

#### gaming.nix - Gaming Configuration

Comprehensive gaming setup for Steam and performance optimization.

**Includes:**
- Steam with GameScope, remote play, dedicated servers
- GameMode for automatic performance optimization
- XWayland support (required for Steam/games)
- MangoHud and Goverlay for FPS/performance monitoring
- Dedicated Steam games storage mount (`/mnt/steamgames`)
- Optional: Proton-GE, Lutris, Heroic launchers, controller tools

**Usage:**
```nix
# In your host configuration (e.g., hosts/black-mesa/configuration.nix)
{
  imports = [
    ../../modules/nixos/gaming.nix
  ];
}
```

**See:** [Gaming Documentation](./hosts/black-mesa/README.md#gaming-with-steam) for:
- Launching and configuring Steam
- Using GameScope for Wayland gaming
- GameMode for performance optimization
- MangoHud performance overlay
- Proton compatibility layer setup
- Troubleshooting common issues
- Storage management

### Creating NixOS Host Configurations

To add a new NixOS host:

1. **Create host directory**:
   ```bash
   mkdir -p hosts/my-host
   ```

2. **Generate hardware configuration**:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/my-host/hardware-configuration.nix
   ```

3. **Create system configuration** (`hosts/my-host/configuration.nix`):
   ```nix
   { config, pkgs, ... }:

   {
     imports = [
       ./hardware-configuration.nix
       # Add optional modules:
       # ../../modules/nixos/gaming.nix  # For gaming
     ];

     networking.hostName = "my-host";
     time.timeZone = "America/New_York";

     # Enable window manager (Hyprland/Niri)
     programs.hyprland.enable = true;

     # User account
     users.users.anthony = {
       isNormalUser = true;
       extraGroups = [ "networkmanager" "wheel" ];
     };

     system.stateVersion = "25.05";
   }
   ```

4. **Create home-manager config** (`hosts/my-host-home.nix`):
   ```nix
   { config, pkgs, ... }:

   {
     imports = [
       ../modules/hyprland.nix  # Optional window managers
       # ../modules/niri.nix
     ];

     home.username = "anthony";
     home.homeDirectory = "/home/anthony";
   }
   ```

5. **Add to flake.nix**:
   ```nix
   nixosConfigurations = {
     my-host = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
         ./hosts/my-host/configuration.nix
         home-manager.nixosModules.home-manager
         {
           home-manager.useGlobalPkgs = true;
           home-manager.users.anthony = {
             imports = [
               ./home.nix
               ./hosts/my-host-home.nix
             ];
           };
         }
       ];
     };
   };
   ```

6. **Deploy**:
   ```bash
   sudo nixos-rebuild switch --flake .#my-host
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

## Traditional Installation (Without Nix)

If you cannot use Nix (work machines, restricted environments, or personal preference), see [TRADITIONAL-README.md](./TRADITIONAL-README.md) for:
- Homebrew installation (macOS)
- apt/pacman/dnf installation (Linux)
- Manual configuration linking with GNU Stow
- Bootstrap scripts for automatic setup

## Additional Documentation

- **[TRADITIONAL-README.md](./TRADITIONAL-README.md)** - Installation without Nix (Homebrew, apt, pacman, etc.)
- **[hosts/black-mesa/README.md](./hosts/black-mesa/README.md)** - Gaming with Steam on NixOS
- **[modules/nixos/README.md](./modules/nixos/README.md)** - NixOS system modules
- **[packages/README.md](./packages/README.md)** - Package manager lists
- **[scripts/README.md](./scripts/README.md)** - Installation scripts
- **[Claude.md](./Claude.md)** - Context for Claude Code AI

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Nix Package Search](https://search.nixos.org/packages)
- [NixOS Options Search](https://search.nixos.org/options)
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Learn Nix concepts
- [NixOS Wiki](https://nixos.wiki/) - Community documentation
