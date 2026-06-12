# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  description = "Justus' generic system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/master";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    # optionally choose not to download darwin deps (saves some resources on Linux)
    agenix.inputs.darwin.follows = "";
    pomoglorbo = {
      url = "git+https://codeberg.org/justusw/Pomoglorbo.git?ref=refs/tags/2025.8.21";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      pomoglorbo,
      utils,
      disko,
      agenix,
    }@inputs:
    let
      name = "debian";
      mkHomeManagerCfg =
        {
          hostName,
        }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${name}" = import ./home-manager/${hostName}.nix;
          home-manager.extraSpecialArgs = {
            # TODO check if homeDirectory still needed
            homeDirectory = "/home/${name}";
          }
          // {
            inherit name;
          };
        };
      mkNixosConfig =
        {
          # hostname for this machine
          hostName,
          # Use home-manager to configure `name` user?
          addHome,
          # What other NixOS configuration modules should this NixOS machine use?
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit name; };
          modules = [
            ./nixos/${hostName}/configuration.nix
            { networking = { inherit hostName; }; }
          ]
          ++ (nixpkgs.lib.optionals addHome [
            home-manager.nixosModules.home-manager
            (mkHomeManagerCfg { inherit hostName; })
          ])
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        helium = mkNixosConfig {
          hostName = "helium";
          addHome = true;
        };
        helium-cuda = mkNixosConfig {
          hostName = "helium-cuda";
          addHome = false;
        };
        lithium-nixos = mkNixosConfig {
          hostName = "lithium-nixos";
          addHome = true;
        };
        nitrogen = mkNixosConfig {
          hostName = "nitrogen";
          addHome = true;
        };
        carbon = mkNixosConfig {
          hostName = "carbon";
          addHome = true;
          extraModules = [ disko.nixosModules.disko ];
        };
        throwaway = mkNixosConfig {
          hostName = "carbon";
          addHome = true;
          extraModules = [ disko.nixosModules.disko ];
        };
      };
      # TODO refactor
      darwinConfigurations = {
        "lithium" =
          let
            system = "aarch64-darwin";
            hostName = "lithium";
            specialArgs = { inherit name system; };
          in
          nix-darwin.lib.darwinSystem {
            inherit specialArgs;
            modules = [
              { _module.args = inputs; }
              { networking = { inherit hostName; }; }
              {
                # TODO remove overlay?
                nixpkgs.overlays = [
                  (final: previous: {
                    pomoglorbo = pomoglorbo.outputs.packages.${system}.pomoglorbo.overrideAttrs { doCheck = false; };
                  })
                ];
              }
              ./nix-darwin/${hostName}/configuration.nix
              home-manager.darwinModules.home-manager
              (mkHomeManagerCfg { inherit hostName; })
              {
                # XXX only lithium's home manager config misses "homeDirectory"
                # from extraSpecialArgs
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.sharedModules = [
                  # TODO check if NixOS home manager needs this:
                  { _module.args = inputs; }
                ];
              }
            ];
          };
        "hydrogen" =
          let
            hostName = "hydrogen";
          in
          nix-darwin.lib.darwinSystem {
            specialArgs = { inherit name; };
            modules = [
              { _module.args = inputs; }
              { networking = { inherit hostName; }; }
              ./nix-darwin/${hostName}/configuration.nix
              home-manager.darwinModules.home-manager
              (mkHomeManagerCfg { inherit hostName; })
              {
                home-manager.sharedModules = [
                  { _module.args = inputs; }
                ];
              }
            ];
          };
      };
    }
    // utils.lib.eachDefaultSystem (
      system:
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
            luaformatter
            reuse
            nixfmt-tree
          ];
        };
        # Format .nix files in this repository with the following command:
        # nix fmt
        formatter = pkgs.nixfmt-tree;
        packages.disko-install = disko.outputs.packages.${system}.disko-install;
      }
    );
}
