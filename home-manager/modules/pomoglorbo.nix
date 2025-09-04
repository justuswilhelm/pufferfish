{ pkgs, ... }:
{
  home.packages = [ pkgs.pomoglorbo ];
  xdg.configFile."pomoglorbo/config.ini".source = ../../pomoglorbo/config.ini;
  programs.fish.shellAliases = {
    p = "pomoglorbo";
  };
}
