{ pkgs, ... }:
{
  home.packages = [ pkgs.pomoglorbo ];
  xdg.configFile.pomoglorbo = {
    source = ../pomoglorbo/config.ini;
    target = "pomoglorbo/config.ini";
  };
}
