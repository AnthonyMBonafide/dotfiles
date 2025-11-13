# Black Mesa NixOS Configuration

This directory contains the NixOS system configuration for the Black Mesa host.

## Initial Setup on New Machine

### 1. Install NixOS

First, install NixOS on your new machine using the standard installer. You can use a minimal install - the configuration will add everything needed.

### 2. Clone the Dotfiles Repository

After the initial installation and first boot:

```bash
# Install git if not already available
nix-shell -p git

# Clone the dotfiles repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Generate Hardware Configuration

Generate the hardware configuration for your new machine:

```bash
sudo nixos-generate-config --show-hardware-config > ~/dotfiles/hosts/black-mesa/hardware-configuration.nix
```

**Important:** This step is critical! The hardware configuration contains:
- Filesystem mount points
- Boot loader settings specific to your hardware
- Hardware-specific kernel modules
- Network interface configurations

### 4. Review and Customize (Optional)

Before deploying, you may want to customize:

- **Hostname**: Already set to `black-mesa` in `configuration.nix:17`
- **Timezone**: Currently set to `America/New_York` in `configuration.nix:28`
- **Auto-login**: Enabled for user `anthony` - disable if unwanted in `configuration.nix:169-170`
- **User account**: Username is `anthony` - change if needed in `configuration.nix:131`

### 5. Build and Deploy

Deploy the configuration to your new machine:

```bash
sudo nixos-rebuild switch --flake ~/dotfiles#black-mesa
```

This will:
- Build the new system configuration
- Download all required packages
- Set up Home Manager with all your dotfiles
- Configure both Hyprland and Niri window managers
- Install all development tools, editors, and CLI utilities

### 6. Reboot

After the first deployment, reboot to ensure everything is loaded correctly:

```bash
sudo reboot
```

## What's Included

This configuration inherits all modules from the shared configuration:

### System-Level
- **Window Managers**: Hyprland and Niri (both available at GDM login)
- **Display Manager**: GDM with Wayland
- **Desktop Environment**: GNOME (as fallback)
- **Audio**: PipeWire with ALSA and PulseAudio support
- **Bluetooth**: Enabled but off by default (battery saving)
- **Networking**: NetworkManager
- **Auto-login**: Enabled for user `anthony`

### User-Level (Home Manager)
- **Shell**: Fish with Starship prompt and Atuin history
- **Editors**: Neovim (LazyVim), Helix
- **Development**: Git, Go, Rust, Python, Node.js, and more
- **Terminal**: Alacritty, Kitty, and other terminal emulators
- **CLI Tools**: fd, ripgrep, bat, eza, zoxide, and more
- **Fonts**: Nerd Fonts and other development fonts

### Maintenance Features
- **Garbage Collection**: Automatic weekly cleanup (30-day retention)
- **Store Optimization**: Automatic deduplication of Nix store
- **Boot Entries**: Limited to 10 entries to prevent /boot from filling

## Updating the Configuration

To update the configuration after making changes:

```bash
cd ~/dotfiles

# Pull latest changes if using git
git pull

# Rebuild and switch
sudo nixos-rebuild switch --flake .#nixos-laptop
```

## Updating Packages

To update all packages to their latest versions:

```bash
cd ~/dotfiles

# Update flake inputs
nix flake update

# Rebuild with updated packages
sudo nixos-rebuild switch --flake .#nixos-laptop
```

## Rollback

If something goes wrong, you can easily rollback:

```bash
# List available generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Or boot into a previous generation from the bootloader menu
# (Older generations are available in the systemd-boot menu)
```

## Troubleshooting

### Hardware Detection Issues

If you have hardware detection issues, regenerate the hardware config:

```bash
sudo nixos-generate-config --show-hardware-config > ~/dotfiles/hosts/black-mesa/hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/dotfiles#nixos-laptop
```

### Hostname Conflicts

If you want to change the hostname:

1. Edit `hosts/black-mesa/configuration.nix` line 17
2. Optionally rename the directory and update `flake.nix` references
3. Rebuild: `sudo nixos-rebuild switch --flake ~/dotfiles#new-hostname`

### Window Manager Not Available at Login

If Hyprland or Niri don't appear in GDM:

1. Ensure you're using Wayland session (not X11)
2. Check that the window managers are enabled in `configuration.nix`
3. Rebuild and reboot

## Differences from Desktop Configuration

This configuration is identical to the desktop configuration except for:
- Hostname: `black-mesa` instead of `nixos`
- Hardware configuration: Unique to this machine's hardware

All modules, packages, and settings are shared between both machines.
