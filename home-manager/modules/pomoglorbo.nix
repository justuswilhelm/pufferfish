{ pkgs, ... }:
{
  home.packages = [ pkgs.pomoglorbo ];
  xdg.configFile."pomoglorbo/config.ini".source = ../../pomoglorbo/config.ini;
}
