{
  description = "Anthony's Nix Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, nvf, firefox-addons, sops-nix, ... }:
    let
      # Helper function to create home configuration for a system
      mkHomeConfiguration = { system, hostModule }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            ./home.nix
            hostModule
            nvf.homeManagerModules.default
            {
              # Make flake root and inputs available to all modules
              _module.args.flakeRoot = self;
              _module.args.firefox-addons = firefox-addons.packages.${system};
            }
          ];
        };
    in
    {
      homeConfigurations = {
        # macOS (Apple Silicon) - Current macOS system
        "macbook-pro" = mkHomeConfiguration {
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
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.users.anthony = { ... }: {
                imports = [
                  ./home.nix
                  ./hosts/nixos-desktop.nix
                  nvf.homeManagerModules.default
                ];
                # Make flake root and inputs available to this home-manager configuration
                _module.args.flakeRoot = self;
                _module.args.firefox-addons = firefox-addons.packages."x86_64-linux";
              };
            }
          ];
        };

        black-mesa = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/black-mesa/configuration.nix
            stylix.nixosModules.stylix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.users.anthony = { ... }: {
                imports = [
                  ./home.nix
                  ./hosts/black-mesa-home.nix
                  nvf.homeManagerModules.default
                ];
                # Make flake root and inputs available to this home-manager configuration
                _module.args.flakeRoot = self;
                _module.args.firefox-addons = firefox-addons.packages."x86_64-linux";
              };
            }
          ];
        };
      };
    };

}
