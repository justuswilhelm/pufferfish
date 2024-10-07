{ lib, pkgs, config, ... }:
let
  # Wrap neomutt to ensure true color support
  package =
    pkgs.symlinkJoin {
      name = "neomutt";
      paths = [ pkgs.neomutt ];
      buildInputs = [ pkgs.makeWrapper ];
      # https://neomutt.org/guide/reference.html#color-directcolor
      postBuild = ''
        wrapProgram $out/bin/neomutt --set TERM xterm-direct
      '';
    };
in
{
  programs.neomutt = {
    enable = true;
    inherit package;
    # TODO
    # extraConfig = builtins.readFile ../../neomutt/shared;
  };

  xdg.configFile = {
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
  };
}
