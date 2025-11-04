{ config, pkgs, flakeRoot, ... }:

{
  # CLI tools and utilities
  home.packages = with pkgs; [
    # Modern CLI replacements
    bat          # Better cat
    eza          # Better ls
    fd           # Better find
    ripgrep      # Better grep
    lsd          # LSDeluxe - another ls alternative

    # Search and navigation
    fzf          # Fuzzy finder
    tldr         # Simplified man pages

    # File monitoring and execution
    watchexec    # Execute commands on file changes

    # Data processing
    jq           # JSON processor
    yq           # YAML processor

    # Download tools
    wget

    # Task management
    taskwarrior3  # Task/todo manager (called 'task' in brew)

    # Git tools
    lazygit      # Terminal UI for git
    lazyjj       # Terminal UI for jj

    # Zig language server
    zls

    # Terminal multiplexer
    tmux

    # GNU utilities
    gnupg
    pinentry_mac
  ];

  programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

  # Fish Shell Configuration
  programs.fish = {
    enable = true;

    # Shell initialization
    shellInit = ''
      set fish_greeting

      # Add Nix paths
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end

      # Add home-manager session variables
      set -gx PATH $HOME/.nix-profile/bin $PATH
    '';

    # Environment variables
    shellAbbrs = {
        src = "source ~/.config/fish/config.fish";
        gb = "go build ./... && go test -run=XXX_SHOULD_NEVER_MATCH_XXX ./...";
        gbt = "go test -run=XXX_SHOULD_NEVER_MATCH_XXX ./...";
        n = "nvim";
        ls = "eza";
        l = "eza -al --icons always -b --git";
        lt = "eza -al --icons always -b --git --total-size -T";
        cd = "z";
        ".." = "z ..";
        pms = "podman machine start";
        hms = "home-manager switch --flake .#Anthony";

# Git
        g = "git";
        gf = "git fetch --all";
        grom = "git rebase $DEFAULT_ORIGN/$DEFAULT_BRANCH";
        gfrom = "git fetch --all && git rebase origin/main";
        gp = "git push origin HEAD";
        gpwl = "git push origin HEAD --force-with-lease";
        ga = "git add .";
        gc = "git commit -s -S";
        gca = "git commit -s -S -a -u";
        gs = "git status";
        gl = "git log";
        gd = "git diff";
        gwta = "gf && git worktreea";
        gcpe = "git commit -s -S -a -u && git push origin HEAD";
        gcpef = "git commit -s -S -a -u && git push origin HEAD --force-with-lease";
        gwtr = "git worktree remove";
        gwtrf = "git worktree remove --force";

        # JJ aliases
        jbc = "jj bookmark create -r@ AnthonyMBonafide/";
        jbla = "jj bookmark list -a";
        jbl = "jj bookmark list";
        jgp = "jj git push -r@ --allow-new";
        jbm = "jj bookmark move -f@- -t@";
        jrm = "jj rebase -s @ -d main";
        jgf = "jj git fetch";
        jd = "jj desc";
      };
  };

  # Note: If you have alias files, you can still source them:
  # Source existing fish configuration files
  xdg.configFile."fish/conf.d/rustup.fish".source = flakeRoot + /.config/fish/conf.d/rustup.fish;

  # If the alias files exist, you can source them too
  # Uncomment these if the files exist:
  # xdg.configFile."fish/.dockeraliases.fish".source = ../.config/fish/.dockeraliases.fish;
  # xdg.configFile."fish/.workaliases.fish".source = ../.config/fish/.workaliases.fish;
  # xdg.configFile."fish/.gitaliases.fish".source = ../.config/fish/.gitaliases.fish;
  # xdg.configFile."fish/.brewaliases.fish".source = ../.config/fish/.brewaliases.fish;
  # xdg.configFile."fish/.clitools.fish".source = ../.config/fish/.clitools.fish;

  # Environment variables set via home.sessionVariables
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  # Starship Prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Symlink the starship config file instead of reading it at build time
  xdg.configFile."starship.toml".source = flakeRoot + /.config/starship.toml;

  # Atuin - Shell History
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    # Reference existing atuin config
    settings = {
      enter_accept = true;
      sync = {
        records = true;
      };
      # Add other settings from your config.toml as needed
      # Most defaults in the config file are commented out, so only the above are explicitly set
    };
  };
}
