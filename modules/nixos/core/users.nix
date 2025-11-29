{ config, pkgs, lib, ... }:

{
  # Define a user account
  users.users.anthony = {
    isNormalUser = true;
    description = "Anthony Bonafide";
    extraGroups = [ "networkmanager" "wheel" "plugdev" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      git
    ];
  };

  # Enable fish shell system-wide
  programs.fish.enable = true;

  # Create plugdev group for hardware device access
  users.groups.plugdev = {};
}
