# Home Manager Modules

This directory contains Home Manager modules for user-level configurations. These modules are cross-platform and work on both NixOS and standalone Home Manager installations (macOS, other Linux distros).

## Directory Structure

```
home/
├── desktop/           # Desktop environment configuration
│   └── common.nix     # Shared config for NixOS desktops (Niri + screensaver)
├── development/       # Development tools and configuration
│   ├── default.nix    # Git config, dev CLI tools (lazygit, nixd, etc.)
│   └── nvf/           # Neovim configuration (modular)
│       ├── default.nix      # Main config with imports
│       ├── options.nix      # Vim options (tabs, clipboard, etc.)
│       ├── lsp.nix          # LSP and language servers
│       ├── dap.nix          # Debug adapters
│       ├── plugins.nix      # Extra plugins
│       └── keybindings.nix  # Key mappings
├── niri/              # Niri window manager (scrollable-tiling Wayland)
│   ├── default.nix    # Packages and module options
│   ├── config.nix     # Niri KDL configuration
│   └── waybar.nix     # Waybar status bar config
├── shell/             # Shell environment
│   ├── default.nix    # Shell aggregator
│   ├── fish.nix       # Fish shell config
│   ├── packages.nix   # CLI utilities
│   └── aliases.nix    # Command aliases
├── editors.nix        # Editor tools and formatters
├── firefox.nix        # Firefox browser with extensions
├── packages.nix       # General user packages (Discord, Spotify)
├── screensaver.nix    # Swaylock screensaver config
├── ssh.nix            # SSH client configuration
├── terminals.nix      # Terminal emulator configuration
└── yubikey-keys.nix   # YubiKey SSH key management
```

## Module Organization Philosophy

### Desktop vs System
- **desktop/** - Desktop environment user configs (window manager, screensaver)
- **system/** (`../system/`) - System-level NixOS modules (services, drivers, hardware)

### Development vs Shell
- **development/** - Programming tools (Git, LSP, debuggers, IDE)
- **shell/** - General CLI utilities and shell environment (fish, bat, eza, fzf)

## Using Modules

### Importing in home.nix

```nix
{
  imports = [
    ./modules/home/shell
    ./modules/home/development
    ./modules/home/firefox.nix
    # ... other modules
  ];
}
```

### Module Options

Some modules provide options for customization:

#### Niri Module

```nix
{
  myHome.niri = {
    enable = true;  # Enable Niri window manager
    wallpaper = myCustomWallpaper;  # Override default wallpaper
    extraPackages = [ pkgs.some-tool ];  # Add extra packages
  };
}
```

## Creating New Modules

### Simple Module Template

```nix
{ config, pkgs, ... }:

{
  # Module description
  # What this configures

  # User packages
  home.packages = with pkgs; [
    # your-package
  ];

  # Program configuration
  programs.your-program = {
    enable = true;
    # settings...
  };
}
```

### Module with Options Template

```nix
{ config, pkgs, lib, ... }:

let
  cfg = config.myHome.yourModule;
in
{
  options.myHome.yourModule = {
    enable = lib.mkEnableOption "Your module description";

    customOption = lib.mkOption {
      type = lib.types.str;
      default = "default-value";
      description = "Description of the option";
    };
  };

  config = lib.mkIf cfg.enable {
    # Your configuration here
  };
}
```

## Best Practices

1. **Modularity** - Keep modules focused on a single concern
2. **Documentation** - Comment non-obvious configurations
3. **Cross-platform** - Use `pkgs.stdenv.isDarwin` / `isLinux` for platform-specific configs
4. **Options** - Add options for reusable modules (like niri)
5. **Defaults** - Provide sensible defaults, allow overrides

## Platform-Specific Configuration

```nix
{
  home.packages = with pkgs; [
    # Common packages
    git
    neovim
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific
    pinentry_mac
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux-specific
    pinentry-curses
  ];
}
```

## Related Documentation

- [System Modules](../system/README.md) - NixOS system-level modules
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
