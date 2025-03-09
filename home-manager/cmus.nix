{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.cmus;
in
{
  options.programs.cmus = {
    output_plugin = mkOption {
      type = types.str;
      default = "pulse";
      example = "coreaudio";
      description = "Which output plugin to use, see cmus --plugins";
    };
  };

  config = mkIf cfg.enable {
    programs.cmus.extraConfig = ''
      set output_plugin=${cfg.output_plugin}
      ${builtins.readFile ../cmus/rc}
    '';
  };
}
