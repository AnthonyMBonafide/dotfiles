{ config, pkgs, flakeRoot, ... }:

{
  # Development packages
  home.packages = with pkgs; [
    jujutsu
    # Languages & Compilers
    gcc
    go
    rust-analyzer

    # Go tools
    golangci-lint

    # API & Testing tools
    bruno  # API client (if available in nixpkgs)

    # Build & Task tools
    qemu

    # Container tools
    podman-compose

    # Kafka tools
    kcat

    # GitHub CLI (managed manually for config preservation)
    gh

    # AI Development tools
    claude-code

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
  # Note: We're not using programs.gh.enable because we want to manage the config files manually
  # to preserve your existing gh configuration exactly as-is
  # Link gh config files directly
  xdg.configFile."gh/config.yml".source = flakeRoot + /.config/gh/config.yml;
  xdg.configFile."gh/hosts.yml".source = flakeRoot + /.config/gh/hosts.yml;
}
