# TODO make this a Nix module
{ specialArgs, ... }:
let
  uid = 501;
  name = specialArgs.name;
in
{
  # Rid ourselves of Apple Music automatically launching
  # https://apple.stackexchange.com/questions/372948/how-can-i-prevent-music-app-from-starting-automatically-randomly/373557#373557
  # Does this actually work? Might have to revisit this
  # Other sources say this works:
  # launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
  # But unload is deprecated in newer versions of launchd
  system.activationScripts.disable-rcd = {
    text = ''
      if launchctl print gui/501/com.apple.rcd; then
        sudo -u ${name} launchctl bootout gui/${builtins.toString uid}/com.apple.rcd || echo "Someone has already booted out com.apple.rcd"
        sudo -u ${name} launchctl disable gui/${builtins.toString uid}/com.apple.rcd || echo "Someone has already disabled com.apple.rcd"
      fi
    '';
  };
}
