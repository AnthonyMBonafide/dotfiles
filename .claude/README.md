# NixOS Dotfiles Project Guide

This is Anthony's NixOS and Home Manager configuration using Nix flakes. The project manages configurations for multiple hosts across different platforms.

## Project Structure

```
dotfiles/
├── flake.nix                    # Main flake configuration with inputs and outputs
├── flake.lock                   # Locked versions of flake inputs
├── home.nix                     # Base Home Manager configuration
│
├── hosts/                       # Host-specific configurations
│   ├── lambda-core/            # NixOS desktop (x86_64-linux)
│   │   ├── configuration.nix   # System configuration
│   │   ├── hardware-configuration.nix
│   │   └── home.nix           # Host-specific home-manager config
│   ├── black-mesa/            # NixOS laptop (x86_64-linux)
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   └── macbook-pro/           # macOS system (aarch64-darwin)
│       └── home.nix           # Standalone home-manager for macOS
│
├── modules/                    # Reusable configuration modules
│   ├── home/                  # Home Manager modules
│   │   ├── desktop/
│   │   │   └── common.nix     # Common desktop environment settings
│   │   ├── development/
│   │   │   ├── default.nix    # Git config, dev tools (alejandra, nixd, statix)
│   │   │   └── nvf/          # Neovim configuration using nvf
│   │   │       ├── default.nix
│   │   │       ├── plugins.nix
│   │   │       ├── options.nix
│   │   │       ├── dap.nix    # Debug Adapter Protocol
│   │   │       ├── keybindings.nix
│   │   │       └── lsp.nix    # Language Server Protocol
│   │   ├── niri/             # Niri window manager configuration
│   │   │   ├── default.nix
│   │   │   ├── config.nix
│   │   │   └── waybar.nix
│   │   ├── shell/
│   │   │   ├── default.nix
│   │   │   ├── fish.nix      # Fish shell configuration
│   │   │   ├── aliases.nix
│   │   │   └── packages.nix
│   │   ├── firefox.nix       # Firefox configuration
│   │   ├── terminals.nix     # Terminal emulators (Kitty, Alacritty)
│   │   ├── editors.nix       # Text editors
│   │   ├── packages.nix      # General home packages
│   │   ├── ssh.nix          # SSH configuration
│   │   ├── screensaver.nix
│   │   └── yubikey-keys.nix  # YubiKey SSH key management
│   │
│   └── system/               # NixOS system modules
│       ├── core/
│       │   ├── common.nix           # Core system settings
│       │   ├── nix-settings.nix     # Nix daemon settings
│       │   ├── users.nix            # User account configuration
│       │   └── auto-update.nix      # Automatic system updates
│       ├── desktop/
│       │   ├── desktop-base.nix     # Desktop environment base
│       │   └── audio.nix            # Audio (PipeWire) configuration
│       └── hardware/
│           ├── gaming.nix           # Gaming hardware/software (Steam)
│           └── yubikey.nix          # YubiKey system integration
│
├── docs/                     # Documentation
│   ├── yubikey-ssh-signing.md
│   └── yubikey-luks-enrollment.md
│
├── packages/                 # Custom package definitions
├── scripts/                  # Utility scripts
└── .claude/                 # Claude Code configuration
    ├── README.md           # This file
    └── settings.local.json # Claude Code settings
```

## Flake Inputs

The project uses the following flake inputs (from flake.nix:4-22):

- **nixpkgs**: NixOS/nixpkgs (nixos-25.11 stable channel)
- **home-manager**: nix-community/home-manager (release-25.11)
- **nvf**: notashelf/nvf - Neovim configuration framework
- **stylix**: danth/stylix - System-wide theming
- **firefox-addons**: rycee/nur-expressions - Firefox extensions

## NixOS Systems

### lambda-core (x86_64-linux)
Desktop system configuration at hosts/lambda-core/

### black-mesa (x86_64-linux)
Laptop system configuration at hosts/black-mesa/

### macbook-pro (aarch64-darwin)
Standalone Home Manager configuration for macOS

## Key Technologies

- **Window Manager**: Niri (Wayland compositor)
- **Status Bar**: Waybar
- **Terminal**: Kitty, Alacritty
- **Shell**: Fish
- **Editor**: Neovim (configured with nvf)
- **Browser**: Firefox with custom extensions
- **Authentication**: YubiKey with FIDO2 SSH keys
- **Audio**: PipeWire
- **Theme**: Stylix (system-wide theming)

## Development Tools

The following development tools are configured (modules/home/development/default.nix:5-16):

- **claude-code**: AI-powered development assistant
- **lazygit**: Terminal UI for git operations
- **nixd**: Nix language server
- **alejandra**: Nix code formatter
- **statix**: Nix linter for anti-patterns

## Nix Workflow Rules

### IMPORTANT: Testing Changes

When making changes to Nix configurations, ALWAYS test them before adding to the bootloader:

1. **For NixOS system changes** (anything in hosts/*/configuration.nix or modules/system/):
   ```bash
   # First, stage new files in git
   git add <new-files>

   # Test the build (doesn't add to bootloader)
   nh os build

   # If you need to apply changes to test them live
   nh os test

   # Only switch when you're confident everything works
   nh os switch
   ```

2. **For Home Manager changes** (anything in home.nix or modules/home/):
   ```bash
   # Stage new files first
   git add <new-files>

   # Build and activate home-manager config
   home-manager switch
   ```

### Code Formatting

ALWAYS format Nix files using alejandra before committing:

```bash
# Format a single file
alejandra <file.nix>

# Format all Nix files in current directory
alejandra .

# Check formatting without modifying files
alejandra --check .
```

### Git Workflow

1. **Stage new files before building**: New Nix files must be tracked by git for the build system to see them
   ```bash
   git add <new-file.nix>
   ```

2. **Check for warnings**: Always review build output for warnings and fix them immediately

3. **Minimize bootloader entries**: Use `nh os build` and `nh os test` to validate changes before running `nh os switch` to reduce boot menu clutter

## TODO List Usage

When working on this project, use the Claude Code TODO list feature to:

1. Track tasks and subtasks for complex changes
2. Note minor issues that can be resolved later
3. Keep track of warnings or problems discovered during builds
4. Organize multi-file changes (e.g., adding a new module)

Example TODO items:
- "Fix warning in modules/home/shell/fish.nix:42"
- "Update documentation for new YubiKey setup"
- "Refactor common desktop settings into shared module"

## Warning Handling

When you encounter warnings during builds or tests:

1. **Document the warning** in a TODO item if you can't fix it immediately
2. **Fix warnings as soon as possible** - don't let them accumulate
3. **Common warnings to watch for**:
   - Deprecated options
   - Missing dependencies
   - Type mismatches in Nix expressions
   - Git tree dirty warnings (unstaged changes)

## Building and Testing

### Test NixOS Configuration
```bash
# Build without switching (safest, no bootloader entry)
nh os build

# Build and test (temporary, no bootloader entry)
nh os test

# Build and add to bootloader (creates new boot entry)
nh os switch
```

### Update Flake Inputs
```bash
# Update all inputs
nix flake update

# Update specific input
nix flake update nixpkgs
```

### Check Flake
```bash
# Show flake structure
nix flake show

# Check flake for errors
nix flake check
```

## Common Tasks

### Adding a New Package

1. Add to appropriate module in `modules/home/packages.nix` or create new module
2. Stage the file: `git add <file>`
3. Test: `home-manager switch`

### Adding a New NixOS Module

1. Create module in `modules/system/<category>/`
2. Import in host configuration
3. Stage: `git add modules/system/<category>/<new-module.nix>`
4. Format: `alejandra .`
5. Test: `nh os build` then `nh os test`
6. Apply: `nh os switch` (only when confident)

### Modifying Existing Configuration

1. Edit the relevant .nix file
2. Format: `alejandra <file.nix>`
3. For system: `nh os build` then `nh os test`
4. For home: `home-manager switch`
5. Fix any warnings immediately

## Security Notes

- YubiKey FIDO2 keys are used for SSH authentication and git commit signing
- SSH keys are stored in ~/.ssh/ with sk (security key) suffix
- Git commits are automatically signed with SSH key (modules/home/development/default.nix:48-49)
- Allowed signers are automatically generated from YubiKey keys

## Useful References

- Project documentation: docs/
- NixOS Manual: https://nixos.org/manual/nixos/stable/
- Home Manager Manual: https://nix-community.github.io/home-manager/
- Niri Documentation: https://github.com/YaLTeR/niri
