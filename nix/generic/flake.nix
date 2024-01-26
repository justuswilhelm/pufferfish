{
  description = "Justus' generic system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    pomoglorbo = {
      url = "git+https://codeberg.org/justusw/Pomoglorbo.git?ref=main&rev=7859bc36fe08f8dc7248fd75c0b1752c7a8304dd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nix-darwin, home-manager, nixpkgs, nixpkgs-darwin, pomoglorbo }: {
    homeConfigurations."justusperlwitz" =
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ../home-manager/home.nix ];

        extraSpecialArgs = {
          homeBaseDirectory = "/home";
          system = "debian";
          pomoglorbo = pomoglorbo.packages.${system}.pomoglorbo;
        };
      };
    darwinConfigurations."lithium" = let
      system = "aarch64-darwin";
    in
      nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ../darwin/darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.verbose = true;
            home-manager.useUserPackages = true;
            home-manager.users.justusperlwitz = import ../home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              homeBaseDirectory = "/Users";
              system = "darwin";
              pomoglorbo = pomoglorbo.packages.${system}.pomoglorbo;
            };
          }
        ];
      };
  };
}
