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
- ✅ Core modules:
  - `modules/shell.nix` - Fish, Starship, Atuin, CLI tools
  - `modules/terminals.nix` - Alacritty, Kitty, Ghostty, Zellij
  - `modules/development.nix` - Git, Go, databases, dev tools
  - `modules/editors.nix` - Editor configurations
  - `modules/neovim.nix` - Neovim with LazyVim setup
  - `modules/packages.nix` - Fonts, applications, general packages

### What's In Progress
- 🔄 Neovim configuration (recently updated)
- 🔄 Editor modules refinement
- 🔄 Testing full migration from Stow to Nix

### Legacy/Coexisting
- GNU Stow setup still exists (see `README.md`)
- Original config files in `.config/` directory (some symlinked by Nix)
- Homebrew for macOS-specific GUI applications

## Architecture

```
dotfiles/
├── flake.nix              # Main flake configuration with home-manager
├── home.nix               # Home-manager entry point (imports modules)
├── modules/               # Nix modules (organized by category)
│   ├── shell.nix          # Shell environment (Fish, Starship, CLI tools)
│   ├── terminals.nix      # Terminal emulators
│   ├── development.nix    # Development tools, languages, databases
│   ├── editors.nix        # Text editors and formatters
│   ├── neovim.nix         # Neovim-specific configuration
│   └── packages.nix       # Fonts, applications, general packages
├── .config/               # Source configuration files
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
├── README.md              # Original Stow-based documentation
└── NIX-README.md          # Nix Home Manager documentation

Git config files (.gitconfig, .gitignore_global) and tmux (.tmux.conf)
are in the root directory.
```

## Key Design Decisions

### Hybrid Approach
1. **Nix-managed packages**: All CLI tools, development tools, fonts
2. **Symlinked configs**: Complex configs (LazyVim, Starship) kept in `.config/`
3. **Homebrew fallback**: macOS GUI apps that integrate better with system

### Why Symlinks for Some Configs?
- LazyVim has its own plugin manager and update mechanism
- Preserves ability to use configs with or without Nix
- Easier to test changes without rebuilding Nix

### Module Organization
Each module is self-contained and can be commented out in `home.nix` if needed for debugging or platform-specific builds.

## Working with This Project

### Common Tasks

#### Adding a New Package
1. Identify the right module:
   - CLI tool → `modules/shell.nix`
   - Dev tool/language → `modules/development.nix`
   - Editor/formatter → `modules/editors.nix`
   - GUI app/font → `modules/packages.nix`
2. Add package to `home.packages` list
3. Test with: `home-manager switch --flake .#Anthony`

#### Adding a New Configuration
1. If it's a program with home-manager module: Configure in appropriate module file using `programs.<name>.*`
2. If it's a custom config: Add to `.config/` and symlink via `home.file` or `xdg.configFile`

#### Modifying Existing Configs
1. Edit files in `.config/` directory
2. Run: `home-manager switch --flake .#Anthony`
3. Nix will re-symlink updated configurations

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
- [ ] Test on Arch Linux
- [ ] Test on different Arch variants (Manjaro, Endeavor)
- [ ] Create platform-specific configurations
- [ ] Document Windows compatibility approach
- [ ] Full switch from Stow to Nix
- [ ] Archive/remove Stow documentation

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options Search](https://nix-community.github.io/home-manager/options.html)
- [Nix Package Search](https://search.nixos.org/packages)
- [My Nix README](./NIX-README.md)
- [Original Stow README](./README.md)
