{
  description = "Anthony's Nix Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, nixvim, ... }:
    let
      # Helper function to create home configuration for a system
      mkHomeConfiguration = { system, hostModule }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            ./home.nix
            hostModule
            nixvim.homeManagerModules.nixvim
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

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.anthony = { ... }: {
                imports = [
                  ./home.nix
                  ./hosts/nixos-desktop.nix
                  nixvim.homeManagerModules.nixvim
                ];
                # Make flake root available to this home-manager configuration
                _module.args.flakeRoot = self;
              };
            }
          ];
        };

        black-mesa = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/black-mesa/configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.anthony = { ... }: {
                imports = [
                  ./home.nix
                  ./hosts/black-mesa-home.nix
                  nixvim.homeManagerModules.nixvim
                ];
                # Make flake root available to this home-manager configuration
                _module.args.flakeRoot = self;
              };
            }
          ];
        };
      };
    };

}
