{ pkgs, ... }:
{
  programs.nnn = {
    enable = true;
    extraPackages = [
      pkgs.gnused
    ];
  };
  # XXX Does this really work?
  home.sessionVariables.NNN_OPENER = "less";
  home.sessionVariables.NNN_OPTS = "-c";
  # TODO make nnn more useful
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nnn.bookmarks
}
