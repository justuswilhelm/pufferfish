{ pomoglorbo, specialArgs, ... }:
{
  home.packages = [
    pomoglorbo.outputs.packages.${specialArgs.system}.pomoglorbo
  ];
  xdg.configFile.pomoglorbo = {
    source = ../../pomoglorbo/config.ini;
    target = "pomoglorbo/config.ini";
  };
}
