{
  description = "Multi-host NixOS configuration";

  nixConfig = {
    extra-substituters = [ "http://141.144.237.90:8080" ];
    extra-trusted-public-keys = [ "lenovo-cache-1:v7H2hLG7klfw4JqymNByd/GbyRuLAZ5XJpMpHrcxYp4=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    gowin-eda = {
      url = "github:scottwillmoore/nix-gowin-eda";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, nixos-hardware, ... }@inputs:
    let
      mkHost = { hostname, extraModules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.backupFileExtension = "backup";
              home-manager.users."ruter" = import ./home/${hostname}.nix;
            }
          ] ++ extraModules;
        };
    in
    {
      packages.x86_64-linux.gowin-eda-education =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        pkgs.callPackage ./packages/gowin-eda.nix {
          gowinEda = inputs.gowin-eda.packages.${system}.gowin-eda-education;
        };

      nixosConfigurations = {
        lenovo = mkHost { hostname = "lenovo"; };

        surface = mkHost {
          hostname = "surface";
          extraModules = [
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            nixos-hardware.nixosModules.microsoft-surface-common
          ];
        };
      };
    };
}
