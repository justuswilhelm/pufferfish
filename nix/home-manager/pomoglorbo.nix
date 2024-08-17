{ pomoglorbo, specialArgs, ... }:
{
  home.packages = [
    pomoglorbo.packages.${specialArgs.system}.pomoglorbo
  ];
  xdg.configFile.pomoglorbo = {
    source = ../../pomoglorbo/config.ini;
    target = "pomoglorbo/config.ini";
  };
}
