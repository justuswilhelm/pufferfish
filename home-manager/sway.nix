# Contains just sway launcher config now
{ lib, config, pkgs, ... }:
let
  fish = "${config.programs.fish.package}/bin/fish";
  firefox-esr = "${config.programs.firefox.finalPackage}/bin/firefox-esr";
  mosh = "${pkgs.mosh}/bin/mosh";
in
{
  programs.fish.loginShellInit = ''
    # If running from tty1 start sway
    if [ (tty) = /dev/tty1 ]
        exec sway
    end
  '';

  # We always want to enable wayland in moz, since we start sway through the
  # terminal
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;

  home.packages = [ pkgs.phinger-cursors pkgs.clipman ];

  xdg.configFile = {
    swayConfig = {
      text = ''
        ${builtins.readFile ../sway/config}
        # start a terminal
        bindsym $mod+Return exec foot
        bindsym $mod+Shift+Return exec ${firefox-esr}
        # open an url if given in wl clipboard, like example.com
        bindsym $mod+Shift+o exec ${firefox-esr} $(wl-paste)
        # Take a screenshot of a region
        bindsym $mod+Shift+g exec slurp | grim -g - - | wl-copy

        # Launch my currently used workspace
        bindsym $mod+m workspace 1, split horizontal, exec foot ${fish} -c projectify
        # Launch a view into my dotfiles etc
        bindsym $mod+Shift+m workspace 4, exec foot ${fish} -c manage-dotfiles, split horizontal, exec ${firefox-esr}

        # Launch a view into my laptop and do pomodoros
        bindsym $mod+Shift+f workspace 3, exec foot ${mosh} lithium.local -- fish -c tomato
        # Cmus on lithium.local
        bindsym $mod+Shift+t workspace 3, exec foot ${mosh} lithium.local -- fish -c t-cmus
        # start bemenu (a program launcher)
        bindsym $mod+d exec bemenu-run -c --hp 10 --fn 'Iosevka Fixed 16' -p 'bemenu%' | swaymsg exec --

        exec {
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

            # Make sure we have graphical-session.target
            systemctl start --user sway-session.target
        }
      '';
      target = "sway/config";
    };
    swayColors = {
      text = ''
        # Maybe use:
        # https://github.com/jan-warchol/selenized/blob/master/other-apps/i3/i3-selenized-light.conf

        bar {
            status_command i3status
            position top
            bindsym button3 nop
            bindsym button4 nop
            bindsym button5 nop
        }
      '';
      target = "sway/config.d/colors";
    };
    swayGhidra = {
      text = ''
        # Float Ghidra windows, except for big windows
        for_window [class="ghidra-Ghidra"] floating enable
        for_window [title="Ghidra:.*" class="ghidra-Ghidra"] floating disable
        for_window [title="CodeBrowser.*" class="ghidra-Ghidra"] floating disable
        for_window [title="Debugger.*" class="ghidra-Ghidra"] floating disable
        for_window [title="Emulator.*" class="ghidra-Ghidra"] floating disable
      '';
      target = "sway/config.d/ghidra";
    };
    swayCursor = {
      text = ''
        # omg cursor too small depending on which window it hovers over
        # https://wiki.archlinux.org/title/Sway#Change_cursor_theme_and_size
        # https://github.com/swaywm/sway/issues/4610#issuecomment-1310899976
        seat * xcursor_theme phinger-cursors-dark 32
      '';
      target = "sway/config.d/cursor";
    };
  };

  programs.i3status = {
    enable = true;
    enableDefault = false;
    general =
      {
        output_format = "i3bar";
        interval = 5;
      };

    modules = {
      "disk /" = {
        settings = {
          format = "/ %free";
        };
        position = 1;
      };

      "disk /home" = {
        settings = {
          format = "/home %free";
        };
        position = 2;
      };

      load = {
        settings = {
          format = "load: %1min, %5min, %15min";
        };
        position = 3;
      };

      memory = {
        settings = {
          format = "%available / %used";
          threshold_degraded = "10%";
          format_degraded = "MEMORY: %free";
        };
        position = 4;
      };

      "tztime UTC" = {
        settings = {
          format = "UTC %Y-%m-%d %H:%M:%S";
          timezone = "UTC";
        };
        position = 5;
      };

      "tztime local" = {
        settings = {
          format = "LCL %Y-%m-%d %H:%M:%S %Z";
        };
        position = 6;
      };
    };
  };
}
