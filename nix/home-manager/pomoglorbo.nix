{ specialArgs, ... }:
{
  home.packages = [
    specialArgs.pomoglorbo
  ];
  xdg.configFile.pomoglorbo = {
    source = ../../pomoglorbo/config.ini;
    target = "pomoglorbo/config.ini";
  };
}
