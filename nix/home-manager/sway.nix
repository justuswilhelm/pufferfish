# Contains just sway launcher config now
{ pkgs, homeDirectory }:
let
  foot = "${pkgs.foot}/bin/foot";
  fish = "${pkgs.fish}/bin/fish";
  firefox = "${pkgs.firefox-esr}/bin/firefox";
  keepassxc = "${pkgs.keepassxc}/bin/keepassxc";
  grim = "${pkgs.grim}/bin/grim";
in
{
  text = ''
    # start a terminal
    bindsym $mod+Return exec "${foot}"
    bindsym $mod+Shift+Return exec "${firefox}"
    # open an url if given in wl clipboard, like example.com
    bindsym $mod+Shift+o exec "${firefox}" $(wl-paste)
    bindsym $mod+Shift+t exec "${pkgs.tor-browser}/bin/tor-browser"
    bindsym $mod+Shift+p exec "${keepassxc}"
    # Take a screenshot
    bindsym $mod+Shift+b exec "${grim}"
    # Take a screenshot of a region
    bindsym $mod+Shift+g exec "${grim}" -g "$(${pkgs.slurp}/bin/slurp)"

    # Launch my currently used workspace
    bindsym $mod+m exec "${homeDirectory}/.dotfiles/bin/launch-workspace"
    # Launch a view into my dotfiles etc
    bindsym $mod+Shift+m exec "${homeDirectory}/.dotfiles/bin/launch-settings"
    # Launch a view into my laptop
    bindsym $mod+Shift+f exec "${homeDirectory}/.dotfiles/bin/mosh-lithium"
    # start dmenu (a program launcher)
    bindsym $mod+d exec "${pkgs.bemenu}/bin/bemenu-run" -c --hp '10' --fn 'Iosevka Fixed 16' -p 'bemenu%' | swaymsg exec --

    exec {
        # Part of Debian
        opensnitch-ui
        # TODO migrate ibus to sway, there is no Japanese input right now
        # ibus-daemon -dxr
        # Lock after 2 minutes, suspend after six hours
        # Part of debian
        swayidle -w \
            timeout 120 '${homeDirectory}/.dotfiles/bin/lock-screen swayidle' \
            timeout 125 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
            timeout 21600 'systemctl poweroff'
        # Wayland copy-pasting, part of debian
        wl-paste -t text --watch clipman store --no-persist
        # Will these two anyway
        "${pkgs.firefox-esr}/bin/firefox"
        "${pkgs.keepassxc}/bin/keepassxc"
    }
  '';
}
