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
      set lib_sort=genre artist

      # https://manpages.ubuntu.com/manpages/trusty/man1/cmus.1.html
      set format_playlist=%{genre} %{artist} %-15%{album} %3{tracknumber}. %{title}%= %{date} %{duration}

      ${builtins.readFile ../../cmus/rc}
    '';
  };
}
