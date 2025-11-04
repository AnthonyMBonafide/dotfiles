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
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."Anthony" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
          lazyvim.homeManagerModules.default
          {
            # Make flake root available to all modules
            _module.args.flakeRoot = self;
          }
        ];
      };
    };
}
