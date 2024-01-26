{ lib, pkgs, isDarwin, isDebian, homeDirectory }:
let
  selenized = (import ./selenized.nix) { inherit lib; };
in
{
  nixConfig = {
    text = ''
      experimental-features = nix-command flakes
    '';
    target = "nix/nix.conf";
  };
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
  nvimAfter = {
    source = ../../nvim/after;
    target = "nvim/after";
  };
  nvimSelenized = {
    source = ../../nvim/colors/selenized.vim;
    target = "nvim/colors/selenized.vim";
  };
  nvimInit = {
    source = ../../nvim/init.lua;
    target = "nvim/init.lua";
  };
  nvimInitBase = {
    source = ../../nvim/init_base.lua;
    target = "nvim/init_base.lua";
  };
  nvimPlug = {
    source = ../../nvim/autoload/plug.vim;
    target = "nvim/autoload/plug.vim";
  };
  nvimSnippets = {
    source = ../../nvim/snippets;
    target = "nvim/snippets";
  };
  pomoglorbo = {
    source = ../../pomoglorbo/config.ini;
    target = "pomoglorbo/config.ini";
  };
  cmusRc = {
    source = ../../cmus/rc;
    target = "cmus/rc";
  };
  karabiner = {
    enable = isDarwin;
    source = ../../karabiner/karabiner.json;
    target = "karabiner/karabiner.json";
  };
  sway = {
    enable = isDebian;
    source = ../../sway/config;
    target = "sway/config";
  };
  swayColors = {
    enable = isDebian;
    source = ../../sway/config.d/colors;
    target = "sway/config.d/colors";
  };
  pyPoetryDebian = {
    enable = isDebian;
    # We would like to use XDG_CACHE_HOME here
    text = ''
      cache-dir = "${homeDirectory}/.cache/pypoetry"
    '';
    target = "pypoetry/config.toml";
  };
  gdb = {
    enable = isDebian;
    source = ../../gdb/gdbinit;
    target = "gdb/gdbinit";
  };
}
