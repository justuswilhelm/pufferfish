{ lib, pkgs, isDarwin, isDebian, homeDirectory, xdgCacheHome }:
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
    recursive = true;
  };
  pomoglorbo = {
    source = ../../pomoglorbo/config.ini;
    target = "pomoglorbo/config.ini";
  };
  cmusRc = let
    darwinRc = ''
    set output_plugin=coreaudio
    '';
    debianRc = ''
    '';
  in
  {
    text = ''
      ${builtins.readFile ../../cmus/rc}
      ${if isDebian then debianRc else ""}
      ${if isDarwin then darwinRc else ""}
    '';
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
  swayLaunchers = {
    enable = isDebian;
    inherit ((import ./sway.nix) { inherit pkgs homeDirectory; }) text;
    target = "sway/config.d/launchers";
  };
  swayColors = {
    enable = isDebian;
    source = ../../sway/config.d/colors;
    target = "sway/config.d/colors";
  };
  pyPoetryDebian = {
    enable = isDebian;
    text = ''
      cache-dir = "${xdgCacheHome}/pypoetry"
    '';
    target = "pypoetry/config.toml";
  };
  gdb = {
    enable = isDebian;
    source = ../../gdb/gdbinit;
    target = "gdb/gdbinit";
  };
  aerospace = {
    enable = isDarwin;
    source = (import ./aerospace.nix) { inherit pkgs lib homeDirectory; };
    target = "aerospace/aerospace.toml";
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
