{ pkgs, lib, config, ... }:
let
  cfg = config.programs.radare2;
  radare = pkgs.symlinkJoin {
    name = "radare2";
    paths = [ pkgs.radare2 pkgs.meson pkgs.ninja ];
  };
in
{
  options = {
    programs.radare2.enable = lib.mkEnableOption "Install radare2";
  };
  config = {
    home.packages = [ radare ];
  };
}
