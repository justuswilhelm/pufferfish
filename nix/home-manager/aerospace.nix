# Aerospace toml config, returns derivation, not text!
{ lib, pkgs }:
let
  source = builtins.fromTOML (builtins.readFile ../../aerospace/aerospace.toml);
  alacritty = "${pkgs.alacritty}/bin/alacritty";
  extra = {
    mode.main.binding = {
      alt-enter = "exec-and-forget ${alacritty} msg create-window || ${alacritty}";
      # Hardcoded woops
      alt-shift-enter = "exec-and-forget /Applications/Free/Firefox.app/Contents/MacOS/firefox --new-window";
    };
  };
  merged = lib.attrsets.recursiveUpdate source extra;
  tomlFormat = pkgs.formats.toml { };
in
tomlFormat.generate "aerospace.toml" merged
