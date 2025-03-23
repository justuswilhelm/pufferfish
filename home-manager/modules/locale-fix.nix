{ pkgs, ... }:
{
  # Workaround for LANG issue
  # https://github.com/nix-community/home-manager/issues/354#issuecomment-475803163
  home.sessionVariables.LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
}
