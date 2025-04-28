{ pkgs, lib, config, ... }:
let
  cfg = config.programs.radare2;
in
{
  options = {
    programs.radare2.enable = lib.mkEnableOption "Install radare2";
  };
  config = {
    home.packages = [
      # Reverse engineering
      # ===================
      (
        pkgs.symlinkJoin {
          name = "radare2";
          paths = [
            pkgs.radare2
            pkgs.meson
            pkgs.ninja
          ];
        }
      )
    ];
  };
}
