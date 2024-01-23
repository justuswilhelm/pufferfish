# home-manager --extra-experimental-features flakes --extra-experimental-features nix-command switch --flake $HOME/.dotfiles/home-manager
{
  description = "Debian configuration of justusperlwitz";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # XXX is it problematic that the following line says darwin?
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pomoglorbo = {
      url = "git+https://codeberg.org/justusw/Pomoglorbo.git?ref=main&rev=7859bc36fe08f8dc7248fd75c0b1752c7a8304dd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, pomoglorbo, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."justusperlwitz" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

        extraSpecialArgs = {
          homeBaseDirectory = "/home";
          system = "debian";
          pomoglorbo = pomoglorbo.packages.${system}.pomoglorbo;
        };
      };
    };
}
