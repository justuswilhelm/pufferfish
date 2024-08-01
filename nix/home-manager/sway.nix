# Contains just sway launcher config now
{ lib, config, pkgs, specialArgs, osConfig, ... }:
let
  # TODO see if we can add wl-paste as a nix package
  foot = "${pkgs.foot}/bin/foot";
  fish = "${pkgs.fish}/bin/fish";
  firefox-esr = "${config.programs.firefox.finalPackage}/bin/firefox-esr";
  keepassxc = "${pkgs.keepassxc}/bin/keepassxc";
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  bemenu = "${pkgs.bemenu}/bin/bemenu-run";
  mosh = "${pkgs.mosh}/bin/mosh";
in
{
  xdg.configFile = {
    sway = {
      source = ../../sway/config;
      target = "sway/config";
    };
    swayLaunchers = {
      text = ''
        # start a terminal
        bindsym $mod+Return exec ${foot}
        bindsym $mod+Shift+Return exec ${firefox-esr}
        # open an url if given in wl clipboard, like example.com
        bindsym $mod+Shift+o exec ${firefox-esr} $(wl-paste)
        # TODO find a new shortcut for this
        bindsym $mod+Shift+p exec ${keepassxc}
        # Take a screenshot
        bindsym $mod+Shift+b exec ${grim}
        # Take a screenshot of a region
        bindsym $mod+Shift+g exec ${grim} -g $(${slurp})

        # Launch my currently used workspace
        bindsym $mod+m workspace 1, split horizontal, exec ${foot} ${fish} -c projectify
        # Launch a view into my dotfiles etc
        bindsym $mod+Shift+m workspace 4, exec ${foot} ${fish} -c manage-dotfiles, split horizontal, exec ${firefox-esr}

        # Launch a view into my laptop and do pomodoros
        bindsym $mod+Shift+f workspace 3, exec ${foot} ${mosh} lithium.local -- fish -c tomato
        # Cmus on lithium.local
        bindsym $mod+Shift+t workspace 3, exec ${foot} ${mosh} lithium.local -- fish -c t-cmus
        # start bemenu (a program launcher)
        bindsym $mod+d exec ${bemenu} -c --hp 10 --fn 'Iosevka Fixed 16' -p 'bemenu%' | swaymsg exec --

        exec {
            # Part of Debian
            opensnitch-ui
            # TODO migrate ibus to sway, there is no Japanese input right now
            # ibus-daemon -dxr
            # Lock after 2 minutes, suspend after six hours
            # Part of debian
            swayidle -w \
                timeout 120 '${config.home.homeDirectory}/.dotfiles/bin/lock-screen swayidle' \
                timeout 125 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                timeout 21600 'systemctl poweroff'
            # Wayland copy-pasting, part of debian
            wl-paste -t text --watch clipman store --no-persist
            # Will these two anyway
            ${firefox-esr}
        }
      '';
      target = "sway/config.d/launchers";
    };
    swayColors = {
      source = ../../sway/config.d/colors;
      target = "sway/config.d/colors";
    };
  };
}
