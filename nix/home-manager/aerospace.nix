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
  # XXX
  # If telling alacritty to create-window it will not be focused when not
  # focused on another alacritty instance window
  # I am temporarily changing openAlacritty to just always a new instance instead.
  # openAlacritty = cmd: ''exec-and-forget if pgrep -U $USER -f Alacritty.app; then '${alacritty}' msg create-window -e ${cmd}; else open '${alacrittyApp}' --args -e ${cmd}; fi'';
  openAlacritty = cmd: ''exec-and-forget open -n -a '${alacrittyApp}' --args -e ${cmd}'';
  newFirefoxWindow = ''exec-and-forget if pgrep -U $USER -f Firefox.app; then '${firefox}' --new-window; else open -a '${firefoxApp}'; fi'';
  newFinderWindowScript = pkgs.writeText "new-finder-window" ''tell app "Finder" to make new Finder window'';
  runOsaScript = scriptName: "exec-and-forget osascript ${scriptName}";
  extra = {
    mode.main.binding = {
      cmd-alt-enter = openAlacritty fish;
      cmd-alt-shift-enter = newFirefoxWindow;
      cmd-alt-shift-n = runOsaScript newFinderWindowScript;
      # TODO does not properly work right now -- alacritty already has to be launched
      cmd-alt-shift-m = [
        "workspace 4"
        (openAlacritty "${fish} -l -c manage-dotfiles")
        newFirefoxWindow
      ];
      cmd-alt-shift-f = [
        "workspace 3"
        (openAlacritty "${fish} -l -c tomato")
      ];
    };
  };
  merged = lib.attrsets.recursiveUpdate source extra;
  tomlFormat = pkgs.formats.toml { };
in
tomlFormat.generate "aerospace.toml" merged
