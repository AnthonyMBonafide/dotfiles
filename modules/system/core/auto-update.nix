{ config, pkgs, lib, ... }:

{
  # Automatic flake updates
  # This creates a systemd service and timer that runs weekly to:
  # 1. Update all flake inputs (nix flake update)
  # 2. Rebuild the system with updated inputs (nixos-rebuild switch)

  system.autoUpgrade = {
    enable = true;
    flake = config.environment.sessionVariables.FLAKE;
    flags = [
      "--recreate-lock-file"  # Updates ALL flake inputs
      "--commit-lock-file"
    ];
    # Run weekly on Saturdays at 9:30 AM
    dates = "Sat *-*-* 09:30:00";
    # Allow the upgrade to happen even if the system is on battery power
    # Set to false if you want to skip upgrades when on battery
    allowPowerManagement = true;
  };

  # Make the timer persistent - if the system was off during the scheduled time,
  # the update will run when the system boots up
  systemd.timers.nixos-upgrade.timerConfig.Persistent = true;

  # Optionally, reboot after major updates (kernel, initrd, systemd)
  # Set to false if you prefer to manually reboot
  system.autoUpgrade.reboot = lib.mkDefault false;
}
