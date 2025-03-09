{ pkgs, ... }:
{
  xdg.configFile.timewarrior = {
    source = ../timewarrior/timewarrior.cfg;
    target = "timewarrior/timewarrior.cfg";
  };
  home.packages = [
    pkgs.timewarrior
  ];
}
