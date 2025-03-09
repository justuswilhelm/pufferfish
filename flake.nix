{
  description = "Justus' generic system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    pomoglorbo = {
      url = "git+https://codeberg.org/justusw/Pomoglorbo.git?ref=refs/tags/2024.11.22";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    projectify = {
      url = "git+https://github.com/jwpconsulting/projectify.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nix-darwin
    , home-manager
    , nixpkgs
    , nixpkgs-unstable
    , pomoglorbo
    , projectify
    , utils
    }@inputs: {
      nixosConfigurations = {
        helium =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./nix/nixos/helium/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.justusperlwitz = import ./home-manager/helium.nix;
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/justusperlwitz";
                };
              }
            ];
          };
        lithium-nixos =
          let
            system = "aarch64-linux";
            name = "debian";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit name; };
            modules = [
              ./nix/nixos/lithium-nixos/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${name}" = import ./home-manager/lithium-nixos.nix;
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/${name}";
                };
              }
            ];
          };
        nitrogen =
          let
            system = "x86_64-linux";
            name = "debian";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit name; };
            modules = [
              ./nix/nixos/nitrogen/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${name}" = import ./home-manager/nitrogen.nix;
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/${name}";
                };
              }
            ];
          };
      };
      darwinConfigurations."lithium" =
        let
          system = "aarch64-darwin";
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          name = "debian";
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit system name;
          };
          modules = [
            { _module.args = inputs; }
            {
              nixpkgs.overlays = [
                (final: previous: {
                  # XXX
                  # want to use withPlugins, not available in 24.11
                  caddy = pkgs-unstable.caddy;
                })
              ];
            }
            ./nix-darwin/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                { _module.args = inputs; }
              ];
              home-manager.users.debian = import ./home-manager/lithium.nix;
              home-manager.extraSpecialArgs = {
                homeDirectory = "/Users/debian";
                inherit system;
              };
            }
          ];
        };
    } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodePackages.prettier
          shellcheck
        ];
      };
    }
    );
}
