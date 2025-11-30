# System Modules

This directory contains system-level NixOS modules that can be imported into host configurations. These modules handle system services, hardware configuration, and privileged operations.

## Directory Structure

```
system/
├── core/              # Core system configuration
│   ├── common.nix     # Networking, locale, timezone, keyboard
│   ├── nix-settings.nix # Flakes, garbage collection, nh
│   └── users.nix      # User account definitions
├── desktop/           # Desktop environment services
│   ├── desktop-base.nix # XDG portals, Polkit, GDM
│   └── audio.nix      # PipeWire audio configuration
└── hardware/          # Hardware-specific configuration
    ├── gaming.nix     # Steam, GameMode, xwayland-satellite
    └── yubikey.nix    # YubiKey support (U2F, FIDO2, encryption)
```

## Module Descriptions

### Core Modules

#### common.nix
Base system configuration shared across all hosts.

**Includes:**
- Networking configuration
- Locale and timezone
- Keyboard layout
- Printing support (CUPS)
- Bluetooth support

**Usage:**
```nix
imports = [ ../../modules/system/core/common.nix ];
```

#### nix-settings.nix
Nix package manager configuration and automation.

**Includes:**
- Flakes and experimental features
- Auto-optimization and garbage collection
- `nh` (NixOS helper) for simplified rebuilds

**Usage:**
```nix
imports = [ ../../modules/system/core/nix-settings.nix ];
```

#### users.nix
System user account definitions.

**Includes:**
- User accounts with home directories
- Shell configuration (Fish)
- Sudo permissions
- SSH key management

**Usage:**
```nix
imports = [ ../../modules/system/core/users.nix ];
```

### Desktop Modules

#### desktop-base.nix
Desktop environment foundation.

**Includes:**
- X11 support (for XWayland)
- XDG desktop portals
- Polkit authentication agent
- GDM display manager with Wayland

**Usage:**
```nix
imports = [ ../../modules/system/desktop/desktop-base.nix ];
```

#### audio.nix
Audio system configuration.

**Includes:**
- PipeWire audio server
- ALSA and PulseAudio compatibility
- Real-time audio priority

**Usage:**
```nix
imports = [ ../../modules/system/desktop/audio.nix ];
```

### Hardware Modules

#### gaming.nix

Gaming configuration module with Steam, GameMode, and performance optimizations.

**Includes:**
- Steam with GameScope, remote play, and dedicated server support
- GameMode for automatic performance optimization
- XWayland support (required for Steam and most games)
- MangoHud and Goverlay for performance monitoring
- Dedicated Steam games storage mount (`/mnt/steamgames`)
- Optional launchers: Proton-GE, Lutris, Heroic, antimicrox

**Usage:**

Import in your host configuration:

```nix
{
  imports = [
    ../../modules/system/hardware/gaming.nix
  ];
}
```

**Customization:**

Edit `modules/system/hardware/gaming.nix` to:
- Add additional game launchers (uncomment Lutris, Heroic, etc.)
- Modify GameMode settings (CPU governor, GPU performance)
- Change Steam games mount point
- Add controller support tools

**Requirements:**
- NVIDIA or AMD GPU with proper drivers
- Sufficient disk space for games
- Wayland compositor (Hyprland, Niri, etc.)

**See Also:**
- [Black Mesa Gaming Documentation](../../hosts/black-mesa/README.md#gaming-with-steam)
- [Steam on NixOS Wiki](https://nixos.wiki/wiki/Steam)
- [ProtonDB](https://www.protondb.com) for game compatibility

#### yubikey.nix
YubiKey hardware security key support.

**Includes:**
- FIDO2/U2F authentication
- PAM U2F integration (optional)
- LUKS disk encryption support (optional)
- PC/SC daemon for smart card operations

**Options:**
```nix
yubikey.auth.enable = true;        # Enable YubiKey for authentication
yubikey.encryption.enable = true;  # Enable for disk encryption
```

**Usage:**
```nix
{
  imports = [ ../../modules/system/hardware/yubikey.nix ];

  yubikey.auth.enable = true;
  yubikey.encryption.enable = true;
}
```

**See Also:**
- [YubiKey Guide](https://github.com/drduh/YubiKey-Guide)

---

## Creating New System Modules

To create a new system module:

1. Create a new `.nix` file in this directory
2. Use this template:

```nix
{ config, pkgs, ... }:

{
  # Module description
  # What this module configures

  # System packages
  environment.systemPackages = with pkgs; [
    # your-package
  ];

  # System services
  # services.your-service.enable = true;

  # Other system configuration
}
```

3. Import in your host's `configuration.nix`:

```nix
{
  imports = [
    ../../modules/system/your-module.nix
  ];
}
```

4. Document in this README
5. Rebuild: `sudo nixos-rebuild switch --flake ~/dotfiles#hostname`

---

## System Modules vs Home Manager

**Use system modules for:**
- System services (systemd, networking, etc.)
- Hardware configuration (drivers, kernel modules)
- System-wide packages available to all users
- Privileged operations requiring root

**Use Home Manager modules for:**
- User-specific configurations (shell, editor, etc.)
- User packages (installed in user profile)
- Dotfiles and user environment
- Per-user customization

**See:** [Home Manager Modules](../home/README.md)
