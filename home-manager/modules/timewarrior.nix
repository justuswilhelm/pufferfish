{ pkgs, ... }:
{
  xdg.configFile."timewarrior/timewarrior.cfg".source = ../../timewarrior/timewarrior.cfg;
  home.packages = [ pkgs.timewarrior ];
}
