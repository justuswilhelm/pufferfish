{ lib, pkgs, isLinux, homeDirectory, xdgCacheHome }:
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
    source = ../../timewarrior/timewarrior.cfg;
    target = "timewarrior/timewarrior.cfg";
  };
}
