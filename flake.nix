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
            system = "x86_64-linux";
            hostName = "helium";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit system name; };
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
              # TODO remove overlay?
              nixpkgs.overlays = [
                (final: previous: {
                  inherit (pomoglorbo.outputs.packages.${system}) pomoglorbo;
                  inherit (projectify.outputs.packages.${system}) projectify-frontend-node projectify-backend;
                })
                (final: previous: {
                  j = previous.j.overrideAttrs (final: previous: { meta.broken = false; });
                })
                # TODO refactor this and share it with other systems
                (final: previous: rec {
                  valeWithStyles = previous.vale.withStyles (s: [
                    s.alex
                    s.google
                    s.microsoft
                    s.proselint
                    s.write-good
                    s.readability
                  ]);
                  vale-ls = previous.symlinkJoin {
                    name = "vale-ls-with-styles-${previous.vale-ls.version}";
                    paths = [ previous.vale-ls valeWithStyles ];
                    nativeBuildInputs = [ previous.makeBinaryWrapper ];
                    postBuild = ''
                      wrapProgram "$out/bin/vale-ls" \
                        --set VALE_STYLES_PATH "$out/share/vale/styles/"
                    '';
                    meta = {
                      inherit (previous.vale-ls.meta) mainProgram;
                    };
                  };
                })
              ];
            }
            ./nix-darwin/lithium/configuration.nix
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
          name = "debian";
          hostName = "hydrogen";
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
                  j = previous.j.overrideAttrs (final: previous: { meta.broken = false; });
                })
                (final: previous: rec {
                  valeWithStyles = previous.vale.withStyles (s: [
                    s.alex
                    s.google
                    s.microsoft
                    s.proselint
                    s.write-good
                    s.readability
                  ]);
                  vale-ls = previous.symlinkJoin {
                    name = "vale-ls-with-styles-${previous.vale-ls.version}";
                    paths = [ previous.vale-ls valeWithStyles ];
                    nativeBuildInputs = [ previous.makeBinaryWrapper ];
                    postBuild = ''
                      wrapProgram "$out/bin/vale-ls" \
                        --set VALE_STYLES_PATH "$out/share/vale/styles/"
                    '';
                    meta = {
                      inherit (previous.vale-ls.meta) mainProgram;
                    };
                  };
                })
              ];
            }
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
