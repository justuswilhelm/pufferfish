{ lib, pkgs, config, specialArgs, ... }:
with lib;
let
  cfg = config.programs.cmus;
in
{
  options.programs.cmus = {
    enable = mkEnableOption "cmus";
    output_plugin = mkOption {
      type = types.str;
      default = "pulse";
      example = "coreaudio";
      description = "Which output plugin to use, see cmus --plugins";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.cmus
    ];

    xdg.configFile.cmusRc = {
      text = ''
        set output_plugin=${cfg.output_plugin}
        ${builtins.readFile ../../cmus/rc}
      '';
      target = "cmus/rc";
    };
  };
}
