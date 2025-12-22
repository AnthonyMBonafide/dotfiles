# Hardware configuration for Beelink mini computers
# This is a placeholder file that will be replaced by the hardware scan
# during NixOS installation.
#
# To generate the actual hardware configuration:
# nixos-generate-config --show-hardware-config > hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Placeholder configuration
  # Replace this entire file with the output from nixos-generate-config
  # during installation on each Beelink machine

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];  # or "kvm-amd" depending on CPU
  boot.extraModulePackages = [ ];

  # Placeholder filesystem configuration
  # IMPORTANT: Replace these with actual values from nixos-generate-config during installation
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # Additional filesystems can be added here
  # For example, mount points for media storage:
  # fileSystems."/mnt/media" = {
  #   device = "/dev/disk/by-label/media";
  #   fsType = "ext4";
  # };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
