{ lib, pkgs, isLinux, homeDirectory, xdgCacheHome }:
let
  selenized = (import ./selenized.nix) { inherit lib; };
in
{
  fishFunctions = {
    target = "fish/functions";
    source = ../../fish/functions;
    recursive = true;
  };
  neomuttColors = {
    text = selenized.neomutt;
    target = "neomutt/colors";
  };
  neomuttShared = {
    source = ../../neomutt/shared;
    target = "neomutt/shared";
  };
  neomuttMailcap = {
    text =
      let
        convert = pkgs.writeShellApplication {
          name = "convert";
          runtimeInputs = with pkgs; [ pandoc libuchardet ];
          text = ''
            format="$(uchardet "$1")"
            if [ "$format" = "unknown" ]; then
              format="utf-8"
            fi
            iconv -f "$format" -t utf-8 "$1" | pandoc -f html -t plain -
          '';
        };
      in
      ''
        text/html; ${convert}/bin/convert %s; copiousoutput
      '';
    target = "neomutt/mailcap";
  };
  pomoglorbo = {
    source = ../../pomoglorbo/config.ini;
    target = "pomoglorbo/config.ini";
  };
  pyPoetryLinux = {
    enable = isLinux;
    text = ''
      cache-dir = "${xdgCacheHome}/pypoetry"
    '';
    target = "pypoetry/config.toml";
  };
  gdb = {
    enable = isLinux;
    source = ../../gdb/gdbinit;
    target = "gdb/gdbinit";
  };
  timewarrior = {
    text = ''
      ${builtins.readFile ../../timewarrior/timewarrior.cfg}
      ${selenized.timewarrior}
    '';
    target = "timewarrior/timewarrior.cfg";
  };
  radare2 = {
    text = ''
      e cfg.fortunes = true
      e scr.color = 3
      # selenized colors
      ${selenized.radare2}
    '';
    target = "radare2/radare2rc";
  };
}
