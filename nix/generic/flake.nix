{
  description = "Justus' generic system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    pomoglorbo = {
      url = "git+https://codeberg.org/justusw/Pomoglorbo.git?ref=refs/tags/2024.11.22";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    projectify = {
      url = "git+https://github.com/jwpconsulting/projectify.git?tag=2024.8.20";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nix-darwin
    , home-manager
    , nixpkgs
    , nixpkgs-unstable
    , pomoglorbo
    , projectify
    }@inputs: {
      nixosConfigurations = {
        helium =
          let
            system = "x86_64-linux";
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ../nixos/helium/configuration.nix
              home-manager.nixosModules.home-manager
              {
                nixpkgs.overlays = [
                  (final: previous: {
                    john = pkgs-unstable.john;
                  })
                ];
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.justusperlwitz = import ../home-manager/helium.nix;
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/justusperlwitz";
                  system = "nixos";
                  pomoglorbo = pomoglorbo.packages.${system}.pomoglorbo;
                };
              }
            ];
          };
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
              home-manager.sharedModules = [
                { _module.args = inputs; }
              ];
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
