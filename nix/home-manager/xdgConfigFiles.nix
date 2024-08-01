{ lib, pkgs, isLinux, homeDirectory, xdgCacheHome }:
let
  selenized = (import ./selenized.nix) { inherit lib; };
in
{
  pomoglorbo = {
    source = ../../pomoglorbo/config.ini;
    target = "pomoglorbo/config.ini";
  };
  gdb = {
    enable = isLinux;
    source = ../../gdb/gdbinit;
    target = "gdb/gdbinit";
  };
  timewarrior = {
    text = ''
      ${builtins.readFile ../../timewarrior/timewarrior.cfg}
      ${selenized.timewarrior}
    '';
    target = "timewarrior/timewarrior.cfg";
  };
  radare2 = {
    text = ''
      e cfg.fortunes = true
      e scr.color = 3
      # selenized colors
      ${selenized.radare2}
    '';
    target = "radare2/radare2rc";
  };
}
