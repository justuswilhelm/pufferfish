{
  description = "Justus' generic system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/master";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    # optionally choose not to download darwin deps (saves some resources on Linux)
    agenix.inputs.darwin.follows = "";
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
    , disko
    , agenix
    }@inputs: {
      nixosConfigurations = {
        helium =
          let
            name = "debian";
            system = "x86_64-linux";
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
            hostName = "helium";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit system name pkgs-unstable; };
            modules = [
              ./nixos/overlays.nix
              ./nixos/${hostName}/configuration.nix
              { networking = { inherit hostName; }; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                # TODO migrate user
                home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/${name}";
                };
              }
            ];
          };
        lithium-nixos =
          let
            name = "debian";
            hostName = "lithium-nixos";
          in
          nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = { inherit name; };
            modules = [
              ./nixos/${hostName}/configuration.nix
              { networking = { inherit hostName; }; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/${name}";
                };
              }
            ];
          };
        nitrogen =
          let
            name = "debian";
            hostName = "nitrogen";
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit name; };
            modules = [
              ./nixos/${hostName}/configuration.nix
              { networking = { inherit hostName; }; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/${name}";
                };
              }
            ];
          };
        carbon =
          let
            name = "debian";
            hostName = "carbon";
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit name; };
            modules = [
              disko.nixosModules.disko
              ./nixos/${hostName}/configuration.nix
              { networking = { inherit hostName; }; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
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
          hostName = "lithium";
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit name; };
          modules = [
            { _module.args = inputs; }
            { networking = { inherit hostName; }; }
            {
              nixpkgs.overlays = [
                (final: previous: {
                  # XXX
                  # want to use withPlugins, not available in 24.11
                  caddy = pkgs-unstable.caddy;

                  inherit (pomoglorbo.outputs.packages.${system}) pomoglorbo;
                  inherit (projectify.outputs.packages.${system}) projectify-frontend-node projectify-backend;
                })
                (final: previous: {
                  j = previous.j.overrideAttrs (final: previous: { meta.broken = false; });
                })
              ];
            }
            ./nix-darwin/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                { _module.args = inputs; }
              ];
              home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
            }
          ];
        };
      darwinConfigurations."hydrogen" =
        let
          system = "aarch64-darwin";
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          name = "debian";
          hostName = "hydrogen";
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit name; };
          modules = [
            { _module.args = inputs; }
            { networking = { inherit hostName; }; }
            ./nix-darwin/hydrogen/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                { _module.args = inputs; }
              ];
              # home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
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
          nixos-anywhere
          nixos-rebuild
          nixos-generators
          agenix.packages.${system}.default
        ];
      };
      packages.disko-install = disko.outputs.packages.${system}.disko-install;
    }
    );
}
