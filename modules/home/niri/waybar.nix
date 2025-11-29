{ config, pkgs, ... }:

{
  # Waybar configuration for Niri window manager

  xdg.configFile."waybar/config-niri".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 30,
      "spacing": 4,

      "modules-left": ["custom/niri-workspaces", "custom/niri-window"],
      "modules-center": ["clock"],
      "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery", "tray"],

      "custom/niri-workspaces": {
        "format": "{}",
        "exec": "${pkgs.niri}/bin/niri msg --json workspaces | ${pkgs.jq}/bin/jq -r '.[] | .id' | awk '{printf \" %s \", $1}'",
        "interval": 1,
        "on-click": "${pkgs.niri}/bin/niri msg action focus-workspace"
      },

      "custom/niri-window": {
        "format": "{}",
        "exec": "${pkgs.niri}/bin/niri msg --json windows | ${pkgs.jq}/bin/jq -r '.[] | select(.is_focused == true) | .title // \"\"' | head -c 50",
        "interval": 1
      },

      "tray": {
        "spacing": 10
      },

      "clock": {
        "timezone": "America/New_York",
        "tooltip-format": "<big>{:%Y %B}</big>\\n<tt><small>{calendar}</small></tt>",
        "format": "{:%a, %b %d  %I:%M %p}"
      },

      "cpu": {
        "format": " {usage}%",
        "tooltip": false
      },

      "memory": {
        "format": " {}%"
      },

      "battery": {
        "states": {
          "warning": 30,
          "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": " {capacity}%",
        "format-plugged": " {capacity}%",
        "format-alt": "{icon} {time}",
        "format-icons": ["", "", "", "", ""]
      },

      "network": {
        "format-wifi": " {essid} ({signalStrength}%)",
        "format-ethernet": " {ifname}",
        "format-linked": " {ifname} (No IP)",
        "format-disconnected": "⚠ Disconnected",
        "tooltip-format": "{ifname}: {ipaddr}/{cidr}"
      },

      "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-bluetooth": "{icon} {volume}%",
        "format-bluetooth-muted": " {icon}",
        "format-muted": "",
        "format-icons": {
          "headphone": "",
          "hands-free": "",
          "headset": "",
          "phone": "",
          "portable": "",
          "car": "",
          "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
      }
    }
  '';
}
