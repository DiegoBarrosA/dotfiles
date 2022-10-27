{
  description = "Diego's NixOS configuration";

  inputs = {
    # Nix ecosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays;

      legacyPackages = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = with outputs.overlays; [
            additions
            wallpapers
            modifications
          ];
          config.allowUnfree = true;
        });

      packages = forAllSystems
        (system: import ./pkgs { pkgs = legacyPackages.${system}; });
      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = legacyPackages.${system}; };
      });

      hydraJobs = rec {
        inherit packages;
        nixos = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel)
          nixosConfigurations;
        home =
          builtins.mapAttrs (_: cfg: cfg.activationPackage) homeConfigurations;
      };

      nixosConfigurations = rec {
        # Desktop
        cobalto-negro = nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages."x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/cobalto-negro ];
        };
        # Laptop
        amatista-gris = nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages."x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/amatista-gris ];
        };
      };

      homeConfigurations = {
        # Desktop
        "diego@cobalto-negro" = home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/diego/cobalto-negro.nix ];
        };
        # Laptop
        "diego@amatista-gris" = home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/diego/amatista-gris.nix ];
        };
      };

      nixConfig = {
        extra-substituers = [ "https://cache.m7.rs" ];
        extra-trusted-public-keys =
          [ "cache.m7.rs:kszZ/NSwE/TjhOcPPQ16IuUiuRSisdiIwhKZCxguaWg=" ];
      };
    };
}
