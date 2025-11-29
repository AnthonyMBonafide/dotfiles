{ config, pkgs, lib, ... }:

{
  # Enable the X11 windowing system (still needed for XWayland)
  services.xserver.enable = true;

  # XDG Portals for screen sharing and other desktop integrations
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
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

  # Display manager - GDM with Wayland
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
}
