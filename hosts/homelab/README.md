# Homelab Server Configuration

This configuration is designed for Beelink mini computers running as headless servers.

## Services Included

- **Forgejo**: Self-hosted Git server with CI/CD capabilities
  - Default port: 3000
  - Default domain: git.homelab.local

- **Jellyfin**: Media server for streaming movies, TV shows, and music
  - Default port: 8096
  - Web UI: http://[server-ip]:8096

- **Vaultwarden**: Bitwarden-compatible password manager
  - Default port: 8080
  - Rocket port: 8000
  - Default domain: vault.homelab.local

## Installation Instructions

### 1. Prepare Installation Media

Download the latest NixOS ISO from https://nixos.org/download and create a bootable USB drive:

```bash
# On Linux
sudo dd if=nixos-minimal-xx.xx.iso of=/dev/sdX bs=4M status=progress

# Or use a tool like balenaEtcher
```

### 2. Boot and Install NixOS

1. Boot from the USB drive on your Beelink mini computer
2. Set up networking:
   ```bash
   # For WiFi
   sudo systemctl start wpa_supplicant
   wpa_cli

   # For Ethernet (usually automatic)
   ```

3. Partition the disk:
   ```bash
   # List available disks
   lsblk

   # Partition with parted or fdisk
   sudo parted /dev/nvme0n1 -- mklabel gpt
   sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
   sudo parted /dev/nvme0n1 -- set 1 esp on
   sudo parted /dev/nvme0n1 -- mkpart primary 512MiB 100%

   # Format partitions
   sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
   sudo mkfs.ext4 -L nixos /dev/nvme0n1p2

   # Mount filesystems
   sudo mount /dev/disk/by-label/nixos /mnt
   sudo mkdir -p /mnt/boot
   sudo mount /dev/disk/by-label/boot /mnt/boot
   ```

4. Generate hardware configuration:
   ```bash
   sudo nixos-generate-config --root /mnt
   ```

5. Clone this repository and copy the configuration:
   ```bash
   # If you have git access
   git clone https://github.com/yourusername/dotfiles /mnt/etc/nixos/dotfiles

   # Or copy via USB/network

   # Update hardware-configuration.nix with generated one
   sudo cp /mnt/etc/nixos/hardware-configuration.nix \
          /mnt/etc/nixos/dotfiles/hosts/homelab/hardware-configuration.nix
   ```

6. Customize the configuration:
   ```bash
   # Edit hostname and any other settings
   sudo nano /mnt/etc/nixos/dotfiles/hosts/homelab/configuration.nix
   ```

7. Install NixOS:
   ```bash
   sudo nixos-install --flake /mnt/etc/nixos/dotfiles#homelab

   # Set root password when prompted
   # Reboot
   sudo reboot
   ```

### 3. Post-Installation Setup

After installation and first boot:

1. **Set up SSH keys** for remote access:
   ```bash
   # On your local machine
   ssh-copy-id anthony@homelab-ip
   ```

2. **Configure Forgejo**:
   - Navigate to http://homelab-ip:3000
   - Complete initial setup wizard
   - Create admin account
   - After setup, disable registration in the module config

3. **Configure Jellyfin**:
   - Navigate to http://homelab-ip:8096
   - Complete initial setup wizard
   - Add media libraries pointing to `/var/lib/jellyfin/media/`
   - Mount your media storage to these directories

4. **Configure Vaultwarden**:
   - Navigate to http://homelab-ip:8080
   - Create your account
   - **IMPORTANT**: After creating your account, disable signups
   - Set up admin token for admin panel access

5. **Set up HTTPS** (recommended):
   - Configure nginx or Caddy as reverse proxy
   - Use Let's Encrypt for SSL certificates
   - Update service domains accordingly

## Managing Multiple Machines

For your 3 Beelink computers, you have several options:

### Option 1: Same Configuration for All
Use the same `homelab` configuration on all three machines, just change the hostname during installation.

### Option 2: Separate Configurations per Machine
Create separate host configurations:
- `hosts/homelab-01/` - Forgejo server
- `hosts/homelab-02/` - Jellyfin server
- `hosts/homelab-03/` - Vaultwarden server

### Option 3: Clustered Setup
Run all services across all machines for redundancy and load balancing.

## Updating the System

To update your homelab server:

```bash
# Update flake inputs
cd ~/dotfiles
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake .#homelab

# Or use nh if installed
nh os switch
```

## Backup Important Data

Make sure to regularly backup:
- `/var/lib/forgejo/` - Git repositories and database
- `/var/lib/jellyfin/` - Media library metadata
- `/var/lib/bitwarden_rs/` - Password vault (CRITICAL!)

## Troubleshooting

### Service not starting
```bash
# Check service status
systemctl status forgejo
systemctl status jellyfin
systemctl status vaultwarden

# Check logs
journalctl -u forgejo -f
journalctl -u jellyfin -f
journalctl -u vaultwarden -f
```

### Firewall issues
```bash
# Check open ports
sudo ss -tulpn

# Check firewall rules
sudo iptables -L -n -v
```

### Network connectivity
```bash
# Check network interfaces
ip addr show

# Test connectivity
ping -c 3 google.com
```

## Additional Services to Consider

- **Nginx Proxy Manager**: Easy HTTPS reverse proxy
- **Tailscale**: Secure remote access VPN
- **Prometheus + Grafana**: Monitoring and metrics
- **Nextcloud**: File sync and collaboration
- **Home Assistant**: Home automation
- **Plex**: Alternative to Jellyfin
- **AdGuard Home**: Network-wide ad blocking

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Forgejo Documentation](https://forgejo.org/docs/)
- [Jellyfin Documentation](https://jellyfin.org/docs/)
- [Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
