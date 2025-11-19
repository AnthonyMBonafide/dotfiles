{ config, pkgs, ... }:

{
  # Development packages
  home.packages = with pkgs; [
    # AI Development tools
    claude-code
  ];
  # Git Configuration
  programs.git = {
    enable = true;

    settings = {
      # User information
      user = {
        email = "AnthonyMBonafide@pm.me";
        name = "Anthony M. Bonafide";
      };

      # Aliases
      alias = {
        blame = "blame -w -C -C -C";
        diff = "diff --word-diff";
        fetch = "fetch --all";
        commit = "commit -s -S";
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
        signoff = true;
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

      # GPG settings for SSH signing
      gpg = {
        format = "ssh";
        ssh = {
          program = "${pkgs.openssh}/bin/ssh-keygen";
          allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
        };
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

    # SSH-based commit signing
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    # Include conditional configs for work
    includes = [
      {
        condition = "gitdir:~/projects/work/";
        path = "~/projects/work/.gitconfig-work";
      }
    ];
  };

  # Git allowed signers file for SSH signing verification
  # This activation script generates the allowed_signers file from your actual SSH key
  # so it automatically stays in sync when you regenerate keys
  home.activation.generateAllowedSigners = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    SSH_KEY="${config.home.homeDirectory}/.ssh/id_ed25519.pub"
    SIGNERS_FILE="${config.home.homeDirectory}/.config/git/allowed_signers"

    if [ -f "$SSH_KEY" ]; then
      mkdir -p "$(dirname "$SIGNERS_FILE")"
      # Remove old symlink/file if it exists
      $DRY_RUN_CMD rm -f "$SIGNERS_FILE"
      echo "${config.programs.git.settings.user.email} $(cat "$SSH_KEY")" > "$SIGNERS_FILE"
      $DRY_RUN_CMD chmod 644 "$SIGNERS_FILE"
    fi
  '';
}
