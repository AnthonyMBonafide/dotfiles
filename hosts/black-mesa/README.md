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
- **Gaming**: Steam, GameMode, XWayland, MangoHud, Goverlay

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

## Gaming with Steam

Black Mesa includes a dedicated gaming module with Steam and performance optimizations.

### Launching Steam

Steam is installed system-wide and can be launched several ways:

```bash
# From terminal
steam

# From application launcher (Wofi in Hyprland/Niri)
Super + Shift + Space, then type "Steam"

# From GNOME applications menu
```

### Steam Library Location

The configuration includes a dedicated drive for Steam games:

- **Mount Point**: `/mnt/steamgames`
- **Type**: ext4 filesystem
- **Options**: `nofail` (system boots even if drive is missing)

To set Steam to use this library:

1. Launch Steam
2. **Settings** → **Storage**
3. Add library folder: `/mnt/steamgames`
4. Set as default for new installations

### GameScope (Wayland Gaming)

GameScope is enabled for better Wayland compatibility:

```bash
# Launch a game with GameScope
gamescope -- %command%

# Or set as Steam launch option for a game:
# Right-click game → Properties → Launch Options:
gamescope -f -- %command%
```

**GameScope Features:**
- Better performance on Wayland
- Custom resolution/refresh rate
- Integer scaling
- Reduced input latency

### GameMode (Performance Optimization)

GameMode automatically optimizes system performance when games run:

**Features:**
- CPU governor set to performance mode
- Process priority boost
- GPU performance mode (NVIDIA)
- Automatic activation when supported games launch

**Manual activation:**
```bash
# Launch with GameMode
gamemoderun %command%

# Check if GameMode is active
gamemoded -s
```

### MangoHud (Performance Overlay)

MangoHud displays FPS, temperatures, and system stats:

```bash
# Launch game with MangoHud
mangohud %command%

# Or set as Steam launch option:
mangohud %command%
```

**Configure MangoHud:**
```bash
# Launch graphical configurator
goverlay
```

### Proton Compatibility

Steam's Proton allows Windows games on Linux:

1. **Settings** → **Compatibility**
2. Enable "Steam Play for all other titles"
3. Select Proton version (usually latest)

**Per-game Proton version:**
- Right-click game → **Properties** → **Compatibility**
- Force specific Proton version

**Check compatibility:**
- Visit [ProtonDB](https://www.protondb.com)
- Search for your game
- Read compatibility reports and tweaks

### Common Steam Launch Options

Add these in game properties → Launch Options:

```bash
# GameScope + GameMode + MangoHud
gamemoderun gamescope -f -- mangohud %command%

# Force Proton version
PROTON_USE_WINED3D=1 %command%

# Enable DXVK HUD
DXVK_HUD=fps %command%

# Disable Steam Overlay (if causing issues)
LD_PRELOAD= %command%
```

### Troubleshooting Steam

#### Game Won't Launch
1. Check ProtonDB for known issues
2. Try different Proton version
3. Verify game files (Right-click → Properties → Local Files)
4. Check logs: `~/.local/share/Steam/logs/`

#### Poor Performance
```bash
# Launch with GameMode + MangoHud to monitor
gamemoderun mangohud %command%

# Check if NVIDIA GPU is being used
nvidia-smi

# Verify GameMode is active
gamemoded -s
```

#### Graphics Issues
```bash
# Force Vulkan
VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json %command%

# Use DXVK instead of WineD3D
# (Remove PROTON_USE_WINED3D if set)
```

#### Controller Not Detected
1. **Settings** → **Controller** → **General Controller Settings**
2. Enable "PlayStation/Xbox Configuration Support"
3. Test in **Gamepad Test**

### Steam Games Storage Management

Monitor storage usage:
```bash
# Check available space
df -h /mnt/steamgames

# Find largest games
du -sh /mnt/steamgames/steamapps/common/* | sort -h
```

Move games between libraries:
1. Right-click game → **Properties** → **Installed Files**
2. **Move Install Folder**
3. Select destination library

### Additional Gaming Tools (Optional)

Uncomment in `modules/nixos/gaming.nix` to enable:

```nix
# Proton-GE (community Proton with more fixes)
protonup-qt      # GUI to manage Proton-GE versions

# Game Launchers
lutris           # Run games from various platforms
heroic           # Epic Games and GOG launcher

# Controller Tools
antimicrox       # Map controller to keyboard/mouse
```

After uncommenting, rebuild:
```bash
sudo nixos-rebuild switch --flake ~/dotfiles#black-mesa
```

## Differences from Desktop Configuration

This configuration includes gaming-specific modules not present on other hosts:
- **Gaming Module**: Steam, GameMode, GameScope, XWayland
- **NVIDIA Drivers**: Proprietary drivers for gaming performance
- **Steam Games Storage**: Dedicated `/mnt/steamgames` mount point
- **Hostname**: `black-mesa` instead of `nixos`
- **Hardware Configuration**: Unique to this machine's hardware
