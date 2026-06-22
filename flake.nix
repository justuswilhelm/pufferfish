# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  description = "Justus' generic system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
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
    pi.url = "github:lukasl-dev/pi.nix";
    pi.inputs.nixpkgs.follows = "nixpkgs";
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
      pi,
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
      mkDarwinConfig =
        {
          hostName,
          extraModules ? [ ],
        }:
        let
          system = "aarch64-darwin";
        in
        nix-darwin.lib.darwinSystem {
          modules = [
            { networking = { inherit hostName; }; }
            { system.primaryUser = name; }
            ./nix-darwin/${hostName}/configuration.nix
            home-manager.darwinModules.home-manager
            (mkHomeManagerCfg { inherit hostName; })
          ]
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
      darwinConfigurations = {
        "lithium" = mkDarwinConfig {
          hostName = "lithium";
          extraModules = [
            {
              # TODO remove overlay?
              nixpkgs.overlays = [
                pi.overlays.default
                (final: previous: {
                  pomoglorbo =
                    pomoglorbo.outputs.packages.${previous.pkgs.stdenv.hostPlatform.system}.pomoglorbo.overrideAttrs
                      { doCheck = false; };
                })
              ];
            }
          ];
        };
        "hydrogen" = mkDarwinConfig { hostName = "hydrogen"; };
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
            prettier
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
