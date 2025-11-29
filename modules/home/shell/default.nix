{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./fish.nix
    ./aliases.nix
  ];

  # Zoxide - Smart directory navigation
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Direnv - Automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Better Nix integration with caching
  };

  # Starship Prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Atuin - Shell History
  # WORKAROUND: atuin 18.8.0 uses deprecated 'bind -k' syntax incompatible with fish 4.0+
  # TODO: Change enableFishIntegration back to true once atuin > 18.8.0 is available
  # See: https://github.com/atuinsh/atuin/issues/2613
  programs.atuin = {
    enable = true;
    enableFishIntegration = false; # Temporarily disabled - using manual init in fish.nix
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
