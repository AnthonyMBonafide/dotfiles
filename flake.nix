{
  description = "Anthony's Nix Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
    };
  };

  outputs = { self, nixpkgs, home-manager, lazyvim, ... }:
    let
      # Helper function to create home configuration for a system
      mkHomeConfiguration = { system, hostModule }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            ./home.nix
            hostModule
            lazyvim.homeManagerModules.default
            {
              # Make flake root available to all modules
              _module.args.flakeRoot = self;
            }
          ];
        };
    in {
      homeConfigurations = {
        # macOS (Apple Silicon) - Current system
        "macbook-pro" = mkHomeConfiguration {
          system = "aarch64-darwin";
          hostModule = ./hosts/macbook-pro.nix;
        };

        # macOS (Intel) - For older Macs
        "macbook-intel" = mkHomeConfiguration {
          system = "x86_64-darwin";
          hostModule = ./hosts/macbook-pro.nix;  # Reuse same config, different arch
        };

        # Linux (x86_64) - Arch/Manjaro/Endeavor OS
        "arch-desktop" = mkHomeConfiguration {
          system = "x86_64-linux";
          hostModule = ./hosts/arch-desktop.nix;
        };

        # Linux (ARM) - For ARM-based Linux machines (Raspberry Pi, etc.)
        "arch-arm" = mkHomeConfiguration {
          system = "aarch64-linux";
          hostModule = ./hosts/arch-desktop.nix;  # Reuse config, different arch
        };

        # Legacy alias for backward compatibility
        "Anthony" = mkHomeConfiguration {
          system = "aarch64-darwin";
          hostModule = ./hosts/macbook-pro.nix;
        };
      };
    };
}
