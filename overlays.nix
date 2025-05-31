{
  vale =
    (final: previous: rec {
      valeWithStyles = previous.vale.withStyles (s: [
        s.alex
        s.google
        s.microsoft
        s.proselint
        s.write-good
        s.readability
      ]);
      vale-ls = previous.symlinkJoin {
        name = "vale-ls-with-styles-${previous.vale-ls.version}";
        paths = [ previous.vale-ls valeWithStyles ];
        nativeBuildInputs = [ previous.makeBinaryWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/vale-ls" \
          --set VALE_STYLES_PATH "$out/share/vale/styles/"
        '';
        meta = {
          inherit (previous.vale-ls.meta) mainProgram;
        };
      };
    });
}
