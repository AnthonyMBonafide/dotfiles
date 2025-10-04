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
    zoxide       # Smart cd

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
    taskwarrior  # Task/todo manager (called 'task' in brew)

    # Git tools
    lazygit      # Terminal UI for git
    lazyjj       # Terminal UI for jj

    # Zig language server
    zls

    # Other shells (for compatibility)
    zsh

    # Terminal multiplexer
    tmux

    # Dotfiles management
    stow

    # GNU utilities
    gnupg
    pinentry_mac
  ];

  # Fish Shell Configuration
  programs.fish = {
    enable = true;

    # Shell initialization
    shellInit = ''
      set fish_greeting
    '';

    # Interactive shell configuration
    interactiveShellInit = ''
      # Add paths
      fish_add_path /opt/homebrew/opt/llvm/bin
      fish_add_path /opt/homebrew/bin/
      fish_add_path $HOME/go/bin
    '';

    # Shell aliases
    shellAliases = {
      # Note: Individual alias files (.dockeraliases.fish, .workaliases.fish, etc.)
      # should be migrated here or sourced via shellInit if they contain complex logic
    };

    # Environment variables
    shellAbbrs = {};
  };

  # Note: If you have alias files, you can still source them:
  # Source existing fish configuration files
  xdg.configFile."fish/conf.d/rustup.fish".source = ../.config/fish/conf.d/rustup.fish;

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
    GOBIN = "$HOME/go/bin";
    LDFLAGS = "-L/opt/homebrew/opt/llvm/lib";
    CPPFLAGS = "-I/opt/homebrew/opt/llvm/include";
  };

  # Starship Prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Symlink the starship config file instead of reading it at build time
  xdg.configFile."starship.toml".source = ../.config/starship.toml;

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
