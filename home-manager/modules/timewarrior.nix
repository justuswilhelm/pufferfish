{ pkgs, ... }:
{
  xdg.configFile."timewarrior/timewarrior.cfg".source = ../../timewarrior/timewarrior.cfg;
  home.packages = [ pkgs.timewarrior ];
  programs.fish.shellAliases.tw = "timewarrior";
}
