{ lib, pkgs, config, options, ... }:
{
  imports = [
    ./modules/direnv.nix
    ./modules/fish.nix
    ./modules/fonts.nix
    ./modules/git.nix
    ./modules/gpg.nix
    ./modules/man.nix
    ./modules/nnn.nix
    ./modules/nvim.nix
    ./modules/passwordstore.nix
    ./modules/paths.nix
    ./modules/pdb.nix
    ./modules/poetry.nix
    ./modules/selenized.nix
    ./modules/ssh.nix
    ./modules/tmux.nix
  ];
}
