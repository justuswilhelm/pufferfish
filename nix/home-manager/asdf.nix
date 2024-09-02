{ pkgs, ... }:
{
  home.packages = [
    pkgs.asdf-vm
  ];
  programs.fish.interactiveShellInit = ''
    if ! set -q ASDF_DIR
      # ASDF initialization
      set -x ASDF_DIR ${pkgs.asdf-vm}/share/asdf-vm
      source ${pkgs.asdf-vm}/share/asdf-vm/asdf.fish
    end
  '';
}
