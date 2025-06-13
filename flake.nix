{
  description = "Justus' generic system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/master";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    # optionally choose not to download darwin deps (saves some resources on Linux)
    agenix.inputs.darwin.follows = "";
    pomoglorbo = {
      url = "git+https://codeberg.org/justusw/Pomoglorbo.git?ref=refs/tags/2025.5.31";
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
            hostName = "helium";
            system = "x86_64-linux";
            specialArgs = { inherit system name; };
          in
          nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
              ./nixos/${hostName}/configuration.nix
              { networking = { inherit hostName; }; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
                # TODO check if homeDirectory still needed
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/${name}";
                } // specialArgs;
              }
            ];
          };
        lithium-nixos =
          let
            name = "debian";
            hostName = "lithium-nixos";
            system = "aarch64-linux";
            specialArgs = { inherit system name; };
          in
          nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
              ./nixos/${hostName}/configuration.nix
              { networking = { inherit hostName; }; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
                # TODO check if homeDirectory still needed
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/${name}";
                } // specialArgs;
              }
            ];
          };
        nitrogen =
          let
            name = "debian";
            hostName = "nitrogen";
            system = "x86_64-linux";
            specialArgs = { inherit system name; };
          in
          nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
              ./nixos/${hostName}/configuration.nix
              { networking = { inherit hostName; }; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
                # TODO check if homeDirectory still needed
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/${name}";
                } // specialArgs;
              }
            ];
          };
        carbon =
          let
            name = "debian";
            hostName = "carbon";
            system = "x86_64-linux";
            specialArgs = { inherit system name; };
          in
          nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
              disko.nixosModules.disko
              ./nixos/${hostName}/configuration.nix
              { networking = { inherit hostName; }; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
                # TODO check if homeDirectory still needed
                home-manager.extraSpecialArgs = {
                  homeDirectory = "/home/${name}";
                } // specialArgs;
              }
            ];
          };
      };
      darwinConfigurations."lithium" =
        let
          system = "aarch64-darwin";
          name = "debian";
          hostName = "lithium";
          specialArgs = { inherit name system; };
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          inherit specialArgs;
          modules = [
            { _module.args = inputs; }
            { networking = { inherit hostName; }; }
            {
              # TODO remove overlay?
              nixpkgs.overlays = [
                (final: previous: {
                  inherit (pomoglorbo.outputs.packages.${system}) pomoglorbo;
                  inherit (projectify.outputs.packages.${system}) projectify-frontend-node projectify-backend;
                })
              ];
            }
            ./nix-darwin/lithium/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
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
          name = "debian";
          hostName = "hydrogen";
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit name system; };
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
              home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
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
