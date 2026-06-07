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
          name,
          hostName,
          system,
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
            inherit system name;
          };
        };
    in
    {
      nixosConfigurations = {
        helium =
          let
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
              (mkHomeManagerCfg { inherit name hostName system; })
            ];
          };
        helium-cuda =
          let
            hostName = "helium-cuda";
            system = "x86_64-linux";
            specialArgs = { inherit system name; };
          in
          nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
              ./nixos/${hostName}/configuration.nix
              { networking = { inherit hostName; }; }
            ];
          };
        lithium-nixos =
          let
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
              (mkHomeManagerCfg { inherit name hostName system; })
            ];
          };
        nitrogen =
          let
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
              (mkHomeManagerCfg { inherit name hostName system; })
            ];
          };
        carbon =
          let
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
              (mkHomeManagerCfg { inherit name hostName system; })
            ];
          };
        throwaway =
          let
            hostName = "throwaway";
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
              (mkHomeManagerCfg { inherit name hostName system; })
            ];
          };
      };
      darwinConfigurations = {
        "lithium" =
          let
            system = "aarch64-darwin";
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
                    pomoglorbo = pomoglorbo.outputs.packages.${system}.pomoglorbo.overrideAttrs { doCheck = false; };
                  })
                ];
              }
              ./nix-darwin/lithium/configuration.nix
              home-manager.darwinModules.home-manager
              (mkHomeManagerCfg { inherit name hostName system; })
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
            system = "aarch64-darwin";
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
              (mkHomeManagerCfg { inherit name hostName system; })
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
