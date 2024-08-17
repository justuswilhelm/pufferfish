{
  description = "Justus' generic system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    pomoglorbo = {
      url = "git+https://codeberg.org/justusw/Pomoglorbo.git?ref=main&ref=2024.06.23.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    projectify = {
      url = "git+https://github.com/jwpconsulting/projectify.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nix-darwin
    , home-manager
    , nixpkgs
    , pomoglorbo
    , projectify
    }@inputs: {
      nixosConfigurations = {
        lithium-nixos =
          let
            system = "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ../nixos/lithium-nixos/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.frugally-consonant-lanky = import ../home-manager/lithium-nixos.nix;
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/frugally-consonant-lanky";
                  system = "nixos";
                  pomoglorbo = pomoglorbo.packages.${system}.pomoglorbo;
                };
              }
            ];
          };
        nitrogen =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ../nixos/nitrogen/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.justusperlwitz = import ../home-manager/nitrogen.nix;
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/justusperlwitz";
                  inherit system;
                };
              }
            ];
          };
      };
      homeConfigurations."justusperlwitz@nitrogen" =
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ ../home-manager/nitrogen.nix ];

          extraSpecialArgs = {
            homeDirectory = "/home/justusperlwitz";
            inherit system;
          };
        };
      homeConfigurations."justusperlwitz@helium" =
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ ../home-manager/helium.nix ];

          extraSpecialArgs = {
            homeDirectory = "/home/justusperlwitz";
            inherit system;
          };
        };
      darwinConfigurations."lithium" =
        let
          system = "aarch64-darwin";
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit system;
          };
          modules = [
            { _module.args = inputs; }
            ../darwin/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.verbose = true;
              home-manager.useUserPackages = true;
              home-manager.users.justusperlwitz = import ../home-manager/lithium.nix;
              home-manager.extraSpecialArgs = {
                homeDirectory = "/Users/justusperlwitz";
                inherit system;
              };
            }
          ];
        };
    };
}
