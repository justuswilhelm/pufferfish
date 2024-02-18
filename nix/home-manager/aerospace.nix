# Aerospace toml config, returns derivation, not text!
{ lib, pkgs, homeDirectory }:
let
  source = builtins.fromTOML (builtins.readFile ../../aerospace/aerospace.toml);
  # We need to convince macOS to open this as a proper app, not as a child of
  # aerospace
  alacrittyApp = "${homeDirectory}/Applications/Home Manager Apps/Alacritty.app";
  alacritty = "${alacrittyApp}/Contents/MacOS/alacritty";
  # Hardcoded woops
  firefoxApp = "/Applications/Free/Firefox.app";
  firefox = "${firefoxApp}/Contents/MacOS/firefox";
  fish = "${pkgs.fish}/bin/fish";
  openAlacritty = cmd: ''exec-and-forget if pgrep -U $USER -f Alacritty.app; then '${alacritty}' msg create-window -e ${cmd}; else open '${alacrittyApp}' --args -e ${cmd}; fi'';
  newFirefoxWindow = ''exec-and-forget if pgrep -U $USER -f Firefox.app; then '${firefox}' --new-window; else open -a '${firefoxApp}'; fi'';
  extra = {
    mode.main.binding = {
      alt-enter = openAlacritty fish;
      alt-shift-enter = newFirefoxWindow;
      # TODO does not properly work right now -- alacritty already has to be launched
      alt-shift-m = [
        "workspace 4"
        (openAlacritty "${fish} -l -c manage-dotfiles")
        newFirefoxWindow
      ];
      alt-shift-f = [
        "workspace 3"
        (openAlacritty "${fish} -l -c tomato")
      ];
    };
  };
  merged = lib.attrsets.recursiveUpdate source extra;
  tomlFormat = pkgs.formats.toml { };
in
tomlFormat.generate "aerospace.toml" merged
