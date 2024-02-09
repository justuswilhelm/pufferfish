# Aerospace toml config, returns derivation, not text!
{ lib, pkgs }:
let
  source = builtins.fromTOML (builtins.readFile ../../aerospace/aerospace.toml);
  alacritty = "${pkgs.alacritty}/bin/alacritty";
  # Hardcoded woops
  firefox = "/Applications/Free/Firefox.app/Contents/MacOS/firefox";
  fish = "${pkgs.fish}/bin/fish";
  extra = {
    mode.main.binding = {
      alt-enter = "exec-and-forget ${alacritty} msg create-window || ${alacritty}";
      alt-shift-enter = "exec-and-forget ${firefox} --new-window";
      alt-shift-m = [
        "workspace 4"
        "exec-and-forget ${alacritty} msg create-window -e ${fish} -l -c manage-dotfiles"
        "exec-and-forget ${firefox} --new-window"
      ];
    };
  };
  merged = lib.attrsets.recursiveUpdate source extra;
  tomlFormat = pkgs.formats.toml { };
in
tomlFormat.generate "aerospace.toml" merged
