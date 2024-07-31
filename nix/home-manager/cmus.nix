{ lib, pkgs, config, specialArgs, ... }:
let
  output_plugin = if specialArgs.system == "darwin" then "coreaudio" else "pulse";
in
{
  xdg.configFile.cmusRc =
    {
      text = ''
        set output_plugin=${output_plugin}
        ${builtins.readFile ../../cmus/rc}
      '';
      target = "cmus/rc";
    };
}
