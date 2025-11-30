{ config, pkgs, ... }:

{
  # CLI tools and utilities
  home.packages =
    with pkgs;
    [
      # Modern CLI replacements
      bat # Better cat
      eza # Better ls
      fd # Better find
      ripgrep # Better grep
      lsd # LSDeluxe - another ls alternative

      # Search and navigation
      fzf # Fuzzy finder
      tldr # Simplified man pages

      # GNU utilities
      gnupg
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      # macOS-specific packages
      pinentry_mac
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      # Linux-specific packages
      pinentry-curses # or pinentry-gtk2 if you prefer GUI
    ];
}
