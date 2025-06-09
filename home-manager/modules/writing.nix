{ pkgs, ... }:
let
in
{
  home.packages = [
    # Document conversion
    pkgs.pandoc
    pkgs.texliveTeTeX

    # Spellcheckers
    (pkgs.aspellWithDicts (ds: with ds; [ en en-computers ]))
    (pkgs.hunspellWithDicts [ pkgs.hunspellDicts.en-us ])
    pkgs.valeWithStyles
  ];
}
