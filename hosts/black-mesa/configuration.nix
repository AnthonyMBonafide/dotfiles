# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/gaming.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "black-mesa"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # X11 server and XWayland configuration moved to modules/nixos/gaming.nix

  # NVIDIA GPU Configuration
  # Enable proprietary NVIDIA drivers for better multi-monitor support
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;

  hardware.nvidia = {
    # Use the production branch driver (recommended for most users)
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Modesetting is required for Wayland compositors
    modesetting.enable = true;

    # Enable the NVIDIA settings menu
    nvidiaSettings = true;

    # Power management (may help with multi-monitor stability)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Open source kernel module (still beta, use false for stable)
    open = false;
  };

  # Hyprland Configuration
  # Enable Hyprland window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Niri Configuration
  # Enable Niri window manager (scrollable-tiling compositor)
  programs.niri = {
    enable = true;
  };

  # XDG Portals for screen sharing and other desktop integrations
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome  # Niri uses GNOME portal
      xdg-desktop-portal-gtk
    ];
  };

  # Polkit authentication agent (needed for GUI authentication dialogs)
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Enable the GNOME Desktop Environment (keeping as fallback)
  # You can disable this later once you're happy with Hyprland
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;  # Enable Wayland for GDM
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Bluetooth configuration
  # Enable Bluetooth hardware support but disable it on boot to save battery
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;  # Bluetooth will be off by default
  };

  # Enable libinput with natural scrolling for mouse
  services.libinput = {
    enable = true;
    mouse = {
      naturalScrolling = true;
    };
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.anthony = {
    isNormalUser = true;
    description = "Anthony Bonafide";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    #  thunderbird
	git
    ];
  };

  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Nix garbage collection and store optimization (system-level)
  # Note: User-level GC is configured in home.nix via home-manager
  nix.gc = {
    # Automatically clean up old system profiles and unused packages
    automatic = true;

    # Run GC weekly (same schedule as home-manager for consistency)
    dates = "weekly";

    # Delete system generations older than 30 days
    # Keep at least 2-3 recent generations for safe rollback
    options = "--delete-older-than 30d";
  };

  # Automatically optimize the Nix store to save disk space
  # This deduplicates identical files (hard-linking them)
  nix.settings.auto-optimise-store = true;

  # Automatically clean up old boot entries to prevent /boot from filling up
  # This is critical on systems with small /boot partitions
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.grub.configurationLimit = 10;

  # Power Management Configuration
  # Disable automatic suspend and hibernation
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";  # Don't suspend on lid close
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandlePowerKey = "ignore";
      IdleAction = "ignore";
      IdleActionSec = 0;
    };
  };

  # Disable GNOME automatic suspend
  services.gnome.gnome-settings-daemon.enable = true;

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "anthony";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Enable fish shell system-wide
  programs.fish.enable = true;

  # Gaming configuration (Steam, GameMode, etc.) is in modules/nixos/gaming.nix

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    swayidle  # Idle management for Wayland
    swaylock  # Screen locker for Wayland
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
