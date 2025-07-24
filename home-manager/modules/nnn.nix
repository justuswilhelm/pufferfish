{ pkgs, ... }:
{
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override {
      # nnn tries to use gsed on darwin
      extraMakeFlags = [ "CPPFLAGS=-DSED='\"sed\"'" ];
    };
    extraPackages = [
      # gnused is just sed on darwin
      pkgs.gnused
    ];
  };
  # XXX Does this really work?
  home.sessionVariables.NNN_OPENER = "less";
  home.sessionVariables.NNN_OPTS = "ediH";
  # TODO make nnn more useful
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nnn.bookmarks
}
