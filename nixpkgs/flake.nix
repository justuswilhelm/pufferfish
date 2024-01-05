{
  description = "Justus' darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, home-manager, nixpkgs }: {
    darwinConfigurations."lithium" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.verbose = true;
          home-manager.useUserPackages = true;
          home-manager.users.justusperlwitz = import ../home-manager/home.nix;
          home-manager.extraSpecialArgs = {
            homeBaseDirectory = "/Users";
            system = "darwin";
          };
        }
      ];
    };
  };
}
