{ config, pkgs, ... }:

{
  # Gaming configuration module for black-mesa
  # Includes Steam, GameMode, XWayland support, and gaming-specific optimizations

  # Enable X11 windowing system (needed for XWayland support)
  # XWayland is required for Steam and most games which are X11-only
  services.xserver.enable = true;

  # Steam Games Storage
  # Mount dedicated drive for Steam library
  fileSystems."/mnt/steamgames" = {
    device = "/dev/disk/by-uuid/1499f235-0e1a-4caf-8663-c7948bd7097b";
    fsType = "ext4";
    options = [ "nofail" ];  # Don't fail boot if drive is missing
  };

  # Steam Configuration
  # Enable Steam with proper graphics drivers and 32-bit support
  programs.steam = {
    enable = true;

    # Enable GameScope for better Wayland compatibility
    # GameScope is a micro-compositor that can improve Steam gaming on Wayland
    gamescopeSession.enable = true;

    # Remote play and local network game streaming
    remotePlay.openFirewall = true;

    # Enable dedicated server support
    dedicatedServer.openFirewall = true;
  };

  # GameMode for performance optimization during gaming
  # GameMode temporarily applies optimizations when games are running
  # Features: CPU governor changes, process priority, GPU performance mode
  programs.gamemode.enable = true;

  # Additional gaming-related packages
  environment.systemPackages = with pkgs; [
    # XWayland support for Niri
    # (Hyprland has built-in XWayland, but Niri uses xwayland-satellite)
    xwayland-satellite # XWayland support for X11 apps like Steam

    # Game launchers and compatibility layers
    # protonup-qt      # Manage Proton-GE versions (uncomment if needed)
    # lutris           # Game launcher for various platforms (uncomment if needed)
    # heroic           # Epic Games and GOG launcher (uncomment if needed)

    # Gaming utilities
    mangohud           # Gaming overlay for monitoring FPS, temps, etc.
    goverlay           # GUI to configure MangoHud

    # Controller support
    # antimicrox       # Map controller to keyboard/mouse (uncomment if needed)
  ];

  # Enable gamemode for better gaming performance
  # This allows games to request performance optimizations
  programs.gamemode.settings = {
    general = {
      # Automatically nice games to higher priority
      renice = 10;
    };

    # GPU optimizations (works with NVIDIA)
    gpu = {
      apply_gpu_optimisations = "accept-responsibility";
      gpu_device = 0;
      amd_performance_level = "high";
    };
  };
}
