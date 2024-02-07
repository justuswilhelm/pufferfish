# Aerospace toml config, returns derivation, not text!
{ lib, pkgs }:
let
  source = builtins.fromTOML (builtins.readFile ../../aerospace/aerospace.toml);
  alacritty = "${pkgs.alacritty}/bin/alacritty";
  extra = {
    mode.main.binding = {
      alt-enter = "exec-and-forget ${alacritty} msg create-window || ${alacritty}";
    };
  };
  merged = lib.attrsets.recursiveUpdate source extra;
  tomlFormat = pkgs.formats.toml { };
in
tomlFormat.generate "aerospace.toml" merged
