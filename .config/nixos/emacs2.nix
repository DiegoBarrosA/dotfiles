# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    emcode = {
      url = "gitlab:DiegoBarrosA/emcode";
      # build with your own instance of nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, emcode }: {
    nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
      # ...
      modules = [
        emcode.nixosModules.default
        { programs.emacs.enable = true; }
        # ...
      ];
    };
  }
