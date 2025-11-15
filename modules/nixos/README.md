# NixOS System Modules

This directory contains NixOS system-level modules that can be imported into host configurations.

## Available Modules

### gaming.nix

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
    ../../modules/nixos/gaming.nix
  ];
}
```

**Customization:**

Edit `modules/nixos/gaming.nix` to:
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

---

## Creating New NixOS Modules

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
    ../../modules/nixos/your-module.nix
  ];
}
```

4. Document in this README
5. Rebuild: `sudo nixos-rebuild switch --flake ~/dotfiles#hostname`

---

## Module vs Home Manager

**Use NixOS modules for:**
- System services (systemd, networking, etc.)
- Hardware configuration (drivers, kernel modules)
- System-wide packages available to all users
- Privileged operations requiring root

**Use Home Manager modules for:**
- User-specific configurations (shell, editor, etc.)
- User packages (installed in user profile)
- Dotfiles and user environment
- Per-user customization

Home Manager modules are located in `modules/` (parent directory).
