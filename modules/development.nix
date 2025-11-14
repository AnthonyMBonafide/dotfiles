{ config, pkgs, ... }:

{
  # Development packages
  home.packages = with pkgs; [
    jujutsu
    # Languages & Compilers
    # gcc
    # go
    # rust-analyzer

    # Go tools
    # golangci-lint

    # API & Testing tools
    bruno  # API client (if available in nixpkgs)

    # Build & Task tools
    # qemu

    # Container tools
    podman-compose

    # GitHub CLI (managed manually for config preservation)
    gh

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

  # Jujutsu (jj) Configuration
  xdg.configFile."jj/config.toml".text = ''
    #:schema https://jj-vcs.github.io/jj/latest/config-schema.json
    "$schema" = "https://jj-vcs.github.io/jj/latest/config-schema.json"

    [user]
    name = "Anthony M. Bonafide"
    email = "AnthonyMBonafide@pm.me"

    [ui]
    default-command = "log"
    editor = "nvim"

    # override user.email if the repository is located under ~/projects/work
    [[--scope]]
    --when.repositories = ["~/projects/work"]
    [--scope.user]
    email = "anthony.bonafide@shipt.com"

    [revsets]
    # Show commits that are not in `main@origin`
    # log = "present(@) | ancestors(immutable_heads().., 10) | present(trunk())"

    [revset-aliases]
    # set all remote bookmarks (commits pushed to remote branches) to be immutable
    # this has the side effect of making a new change on top of the existing one
    # when pushing changes. Also, displaying with `jj log` or simply `jj`
    'immutable_heads()' = "builtin_immutable_heads() | remote_bookmarks()"

    [signing]
    behavior = "own"
    backend = "ssh"
    key = "~/.ssh/id_ed25519.pub"

    [git]
    colocate = true
    push-new-bookmarks = true
    git_push_bookmark = '"AnthonyMBonafide/push-" ++ change_id.short()'
    # Prevent pushing work in progress or anything explicitly labeled "private"
    private-commits = "description(glob:'wip:*') | description(glob:'private:*')"

    [snapshot]
    # This is the default value, but it's good to be explicit
    max-new-file-size = "1MiB"
  '';

  # GitHub CLI Configuration
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
      };
      version = "1";
    };
  };

  # GitHub CLI hosts configuration
  xdg.configFile."gh/hosts.yml".text = ''
    github.com:
        user: AnthonyMBonafide
        git_protocol: ssh
        users:
            AnthonyMBonafide:
  '';

  # Git allowed signers file for SSH signing verification
  # This activation script generates the allowed_signers file from your actual SSH key
  # so it automatically stays in sync when you regenerate keys
  home.activation.generateAllowedSigners = config.lib.dag.entryAfter ["writeBoundary"] ''
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
