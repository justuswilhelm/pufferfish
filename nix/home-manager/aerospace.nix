# Aerospace toml config, returns derivation, not text!
{ lib, pkgs }: let
  source = builtins.fromTOML (builtins.readFile ../../aerospace/aerospace.toml);
  extra = {
    mode.main.binding.alt-enter = "exec-and-forget ${pkgs.alacritty}/bin/alacritty";
  };
  merged = lib.attrsets.recursiveUpdate source extra;
  tomlFormat = pkgs.formats.toml { };
in
  tomlFormat.generate "aerospace.toml" merged
