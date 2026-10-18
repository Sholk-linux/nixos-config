{
  description = "NixOS configuration for sholk";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, flatpaks, nixvim, rust-overlay, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (import rust-overlay) ];
      };

      hmModule = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.sholk = import ./home/home.nix;
          extraSpecialArgs = { inherit nixvim flatpaks; };
          sharedModules = [
            flatpaks.homeModules.default
            nixvim.homeModules.nixvim
          ];
        };
      };
    in {
      nixosConfigurations.sholk-space = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit rust-overlay; };
        modules = [
          ./hosts/sholk-space
          home-manager.nixosModules.home-manager
          hmModule
        ];
      };

      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit rust-overlay; };
        modules = [
          ./hosts/vm
          home-manager.nixosModules.home-manager
          hmModule
        ];
      };
    };
}
