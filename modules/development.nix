{ config, pkgs, ... }:

{
  # Development packages
  home.packages = with pkgs; [
    # Languages & Compilers
    gcc
    go

    # Go tools
    golangci-lint

    # API & Testing tools
    bruno  # API client (if available in nixpkgs)

    # Build & Task tools
    qemu

    # Documentation
    adr-tools

    # Container tools
    podman-compose

    # Kafka tools
    kcat

    # GitHub CLI (managed manually for config preservation)
    gh
  ];

  # Git Configuration
  programs.git = {
    enable = true;

    # User information
    userEmail = "AnthonyMBonafide@pm.me";
    userName = "Anthony M. Bonafide";

    # Core settings
    extraConfig = {
      # Aliases
      alias = {
        blame = "blame -w -C -C -C";
        diff = "diff --word-diff";
        fetch = "fetch --all";
      };

      # Branch settings
      branch = {
        sort = "-committerdate";
      };

      # Column settings
      column = {
        ui = "auto";
      };

      # Commit settings
      commit = {
        gpgSign = true;
      };

      # Core settings
      core = {
        editor = "nvim";
        excludesFile = "~/.gitignore_global";
        pager = "less";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      };

      # Diff settings
      diff = {
        tool = "vimdiff";
      };

      # GPG settings
      gpg = {
        format = "ssh";
      };

      "gpg \"ssh\"" = {
        program = "/nix/store/bzicv3xa9497vxamn9dcbi71i7n2rn92-openssh-10.0p2/bin/ssh-keygen";
      };

      # Init settings
      init = {
        defaultBranch = "main";
      };

      # Merge settings
      merge = {
        tool = "fugitive";
      };

      "mergetool \"fugitive\"" = {
        cmd = "nvim -d -c \"wincmd l\" \"$LOCAL\" \"$MERGED\" \"$REMOTE\"";
        keepBackup = false;
      };

      # Rerere settings
      rerere = {
        enabled = true;
      };

      # Tag settings
      tag = {
        gpgSign = true;
      };

      # URL rewrites
      "url \"ssh://git@github.com/\"" = {
        insteadOf = "https://github.com/";
      };
    };

    # Include conditional configs for work
    includes = [
      {
        condition = "gitdir:~/projects/work/";
        path = "~/projects/work/.gitconfig-work";
      }
    ];
  };

  # Jujutsu (jj) Configuration
  # Since jj uses TOML and has specific complex configuration,
  # we'll reference the existing config file
  xdg.configFile."jj/config.toml".source = ../.config/jj/config.toml;

  # GitHub CLI Configuration
  # Note: We're not using programs.gh.enable because we want to manage the config files manually
  # to preserve your existing gh configuration exactly as-is
  # Link gh config files directly
  xdg.configFile."gh/config.yml".source = ../.config/gh/config.yml;
  xdg.configFile."gh/hosts.yml".source = ../.config/gh/hosts.yml;
}
