# Modules

This directory contains both NixOS system modules and Home Manager user modules.

## Directory Structure

```
modules/
├── system/    # NixOS system-level modules (services, hardware, system config)
└── home/      # Home Manager user-level modules (dotfiles, user apps, shell)
```

## Module Types

### System Modules (`system/`)

System-level configurations that require root privileges or affect the entire system.

**Examples:**
- Hardware drivers (NVIDIA, gaming peripherals)
- System services (audio, networking, printing)
- Boot configuration
- User accounts
- System-wide packages

**See:** [System Modules Documentation](system/README.md)

### Home Manager Modules (`home/`)

User-level configurations for your personal environment and applications.

**Examples:**
- Shell configuration (fish, aliases)
- Editor setup (Neovim)
- Window manager (Niri)
- Application preferences (Firefox, Git)
- Development tools

**See:** [Home Manager Modules Documentation](home/README.md)

## When to Use Which

| Concern | Use System Module | Use Home Module |
|---------|------------------|-----------------|
| Hardware drivers | ✅ | ❌ |
| System services | ✅ | ❌ |
| Multi-user packages | ✅ | ❌ |
| Shell config | ❌ | ✅ |
| Dotfiles | ❌ | ✅ |
| Personal apps | ❌ | ✅ |
| Dev tools | ❌ | ✅ |

## Module Organization Principles

### 1. Separation of Concerns
Each module handles one specific area (e.g., `git`, `firefox`, `gaming`).

### 2. Layered Architecture
```
├── Core (system/core/)         # Base system config
├── Desktop (system/desktop/)   # Desktop environment
├── Hardware (system/hardware/) # Device-specific config
├── Development (home/development/) # Dev tools
├── Shell (home/shell/)         # CLI environment
└── Applications (home/*.nix)   # User applications
```

### 3. Composability
Modules can be mixed and matched in host configurations:

```nix
# hosts/gaming-pc/configuration.nix
imports = [
  ../../modules/system/core/common.nix
  ../../modules/system/hardware/gaming.nix
];

# hosts/gaming-pc/home.nix
imports = [
  ../../modules/home/desktop/common.nix
  ../../modules/home/development
];
```

### 4. Reusability
Use options for configurable modules:

```nix
# Module definition
options.myHome.niri.enable = lib.mkEnableOption "...";

# Host usage
myHome.niri.enable = true;
```

## Contributing New Modules

1. **Determine module type** - System or Home?
2. **Choose appropriate directory** - Match existing organization
3. **Create the module** - Use templates from respective READMEs
4. **Document the module** - Add comments and update README
5. **Import in host config** - Test with `nixos-rebuild` or `home-manager`

## Best Practices

✅ **DO:**
- Keep modules focused and single-purpose
- Use descriptive names (`gaming.nix`, not `stuff.nix`)
- Add comments explaining non-obvious choices
- Provide options for reusable modules
- Use platform conditionals when needed

❌ **DON'T:**
- Mix system and user concerns in one module
- Create monolithic "everything" modules
- Hardcode host-specific values
- Duplicate configuration across modules

## Examples

### Adding a New System Module

```nix
# modules/system/hardware/my-device.nix
{ config, pkgs, ... }:

{
  # My special device configuration
  hardware.my-device.enable = true;

  environment.systemPackages = with pkgs; [
    my-device-tools
  ];
}
```

### Adding a New Home Module

```nix
# modules/home/my-app.nix
{ config, pkgs, ... }:

{
  # My application configuration
  home.packages = [ pkgs.my-app ];

  programs.my-app = {
    enable = true;
    settings = {
      # ...
    };
  };
}
```

## Resources

- [NixOS Module System](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
