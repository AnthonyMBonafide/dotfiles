{ config, pkgs, ... }:

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
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific packages
    pinentry_mac
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    # Linux-specific packages
    pinentry-curses  # or pinentry-gtk2 if you prefer GUI
  ];

  programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

  # Direnv - Automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;  # Better Nix integration with caching
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

    # Interactive shell config - manually initialize atuin for fish 4.0+ compatibility
    # TODO: Remove this manual initialization once atuin > 18.8.0 fixes the deprecated bind -k syntax
    # See: https://github.com/atuinsh/atuin/issues/2613 and https://github.com/atuinsh/atuin/pull/2616
    # To remove: Delete this entire interactiveShellInit block and set enableFishIntegration = true below
    interactiveShellInit = ''
      # Manual atuin initialization (without deprecated -k syntax for fish 4.0+)
      set -gx ATUIN_SESSION (atuin uuid)
      set --erase ATUIN_HISTORY_ID

      function _atuin_preexec --on-event fish_preexec
          if not test -n "$fish_private_mode"
              set -g ATUIN_HISTORY_ID (atuin history start -- "$argv[1]")
          end
      end

      function _atuin_postexec --on-event fish_postexec
          set -l s $status
          if test -n "$ATUIN_HISTORY_ID"
              ATUIN_LOG=error atuin history end --exit $s -- $ATUIN_HISTORY_ID &>/dev/null &
              disown
          end
          set --erase ATUIN_HISTORY_ID
      end

      function _atuin_search
          set -l keymap_mode
          switch $fish_key_bindings
              case fish_vi_key_bindings
                  switch $fish_bind_mode
                      case default
                          set keymap_mode vim-normal
                      case insert
                          set keymap_mode vim-insert
                  end
              case '*'
                  set keymap_mode emacs
          end

          set -l ATUIN_H (ATUIN_SHELL_FISH=t ATUIN_LOG=error ATUIN_QUERY=(commandline -b) atuin search --keymap-mode=$keymap_mode $argv -i 3>&1 1>&2 2>&3 | string collect)

          if test -n "$ATUIN_H"
              if string match --quiet '__atuin_accept__:*' "$ATUIN_H"
                  set -l ATUIN_HIST (string replace "__atuin_accept__:" "" -- "$ATUIN_H" | string collect)
                  commandline -r "$ATUIN_HIST"
                  commandline -f repaint
                  commandline -f execute
                  return
              else if string match --quiet '__atuin_chain_command__:*' "$ATUIN_H"
                  set -l new_command (string replace "__atuin_chain_command__:" "" -- "$ATUIN_H" | string collect)
                  set -l current_command (commandline -b)
                  commandline -r "$current_command $new_command"
              else
                  commandline -r "$ATUIN_H"
              end
          end

          commandline -f repaint
      end

      function _atuin_bind_up
          if commandline --search-mode; or commandline --paging-mode
              up-or-search
              return
          end

          set -l lineno (commandline --line)
          switch $lineno
              case 1
                  _atuin_search --shell-up-key-binding
              case '*'
                  up-or-search
          end
      end

      # Set up key bindings without deprecated -k syntax
      bind \cr _atuin_search
      bind \eOA _atuin_bind_up
      bind \e\[A _atuin_bind_up

      if bind -M insert > /dev/null 2>&1
          bind -M insert \cr _atuin_search
          bind -M insert \eOA _atuin_bind_up
          bind -M insert \e\[A _atuin_bind_up
      end
      # END of atuin fish 4.0+ workaround - remove everything above once atuin is fixed
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
        hmsm = "home-manager switch --flake .#macbook-pro";
        hmsa = "home-manager switch --flake .#arch-desktop";

# Git
        g = "git";
        gf = "git fetch --all";
        grom = "git rebase origin/main";
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
  # Source rust environment in fish (conditionally to avoid errors if cargo not installed)
  xdg.configFile."fish/conf.d/rustup.fish".text = ''
    if test -f "$HOME/.cargo/env.fish"
      source "$HOME/.cargo/env.fish"
    end
  '';

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

  # Starship configuration with custom jj module
  xdg.configFile."starship.toml".text = ''
    # custom module for jj status
    [custom.jj]
    ignore_timeout = true
    description = "The current jj status"
    detect_folders = [".jj"]
    symbol = "🥋 "
    # Using TOML multi-line string (""") to properly escape the command with single quotes
    command = """
jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
  separate(" ",
    change_id.shortest(4),
    bookmarks,
    "|",
    concat(
      if(conflict, "💥"),
      if(divergent, "🚧"),
      if(hidden, "👻"),
      if(immutable, "🔒"),
    ),
    raw_escape_sequence("\\x1b[1;32m") ++ if(empty, "(empty)"),
    raw_escape_sequence("\\x1b[1;32m") ++ coalesce(
      truncate_end(29, description.first_line(), "…"),
      "(no description set)",
    ) ++ raw_escape_sequence("\\x1b[0m"),
  )
'
"""

    # optionally disable git modules
    [git_state]
    disabled = true

    [git_commit]
    disabled = true

    [git_metrics]
    disabled = true

    [git_branch]
    disabled = true

    # re-enable git_branch as long as we're not in a jj repo
    [custom.git_branch]
    when = true
    command = "jj root >/dev/null 2>&1 || starship module git_branch"
    description = "Only show git_branch if we're not in a jj repo"
  '';

  # Atuin - Shell History
  # WORKAROUND: atuin 18.8.0 uses deprecated 'bind -k' syntax incompatible with fish 4.0+
  # TODO: Change enableFishIntegration back to true once atuin > 18.8.0 is available
  # See: https://github.com/atuinsh/atuin/issues/2613
  programs.atuin = {
    enable = true;
    enableFishIntegration = false;  # Temporarily disabled - using manual init in interactiveShellInit above
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
