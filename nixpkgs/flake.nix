{
  description = "Justus' darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs }: {
    darwinConfigurations."lithium" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./darwin-configuration.nix ];
    };
    overlays = {
      fix-git-annex = final: prev: {
        git-annex = prev.git-annex;
      };
    };
  };
}
