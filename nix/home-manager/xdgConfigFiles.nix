{ lib, pkgs, isDarwin, isDebian, homeDirectory, xdgCacheHome }:
let
  selenized = (import ./selenized.nix) { inherit lib; };
in
{
  nixConfig = {
    text = ''
      experimental-features = nix-command flakes
    '';
    target = "nix/nix.conf";
  };
  fishFunctions = {
    target = "fish/functions";
    source = ../../fish/functions;
    recursive = true;
  };
  neomuttColors = {
    text = selenized.neomutt;
    target = "neomutt/colors";
  };
  neomuttShared = {
    source = ../../neomutt/shared;
    target = "neomutt/shared";
  };
  neomuttMailcap = {
    text =
      let
        convert = pkgs.writeShellApplication {
          name = "convert";
          runtimeInputs = with pkgs; [ pandoc libuchardet ];
          text = ''
            format="$(uchardet "$1")"
            if [ "$format" = "unknown" ]; then
              format="utf-8"
            fi
            iconv -f "$format" -t utf-8 "$1" | pandoc -f html -t plain -
          '';
        };
      in
      ''
        text/html; ${convert}/bin/convert %s; copiousoutput
      '';
    target = "neomutt/mailcap";
  };
  nvimAfter = {
    source = ../../nvim/after;
    target = "nvim/after";
  };
  nvimSelenized = {
    source = ../../nvim/colors/selenized.vim;
    target = "nvim/colors/selenized.vim";
  };
  nvimInit = {
    source = ../../nvim/init.lua;
    target = "nvim/init.lua";
  };
  nvimInitBase = {
    source = ../../nvim/init_base.lua;
    target = "nvim/init_base.lua";
  };
  nvimPlug = {
    source = ../../nvim/autoload/plug.vim;
    target = "nvim/autoload/plug.vim";
  };
  nvimSnippets = {
    source = ../../nvim/snippets;
    target = "nvim/snippets";
  };
  pomoglorbo = {
    source = ../../pomoglorbo/config.ini;
    target = "pomoglorbo/config.ini";
  };
  cmusRc = {
    source = ../../cmus/rc;
    target = "cmus/rc";
  };
  karabiner = {
    enable = isDarwin;
    source = ../../karabiner/karabiner.json;
    target = "karabiner/karabiner.json";
  };
  sway = {
    enable = isDebian;
    source = ../../sway/config;
    target = "sway/config";
  };
  swayLaunchers = {
    enable = isDebian;
    text = ''
      # start a terminal
      bindsym $mod+Return exec "${pkgs.foot}/bin/foot"
      bindsym $mod+Shift+Return exec "${pkgs.firefox-esr}/bin/firefox"
      # open an url if given in wl clipboard, like example.com
      bindsym $mod+Shift+o exec "${pkgs.firefox-esr}/bin/firefox" $(wl-paste)
      bindsym $mod+Shift+t exec "${pkgs.tor-browser}/bin/tor-browser"
      bindsym $mod+Shift+p exec "${pkgs.keepassxc}/bin/keepassxc"
      # Take a screenshot
      bindsym $mod+Shift+b exec "${pkgs.grim}/bin/grim"
      # Take a screenshot of a region
      bindsym $mod+Shift+g exec "${pkgs.grim}/bin/grim" -g "$(${pkgs.slurp}/bin/slurp)"

      # Launch my currently used workspace
      bindsym $mod+m exec "${homeDirectory}/.dotfiles/bin/launch-workspace"
      # Launch a view into my dotfiles etc
      bindsym $mod+Shift+m exec "${homeDirectory}/.dotfiles/bin/launch-settings"
      # Launch a view into my laptop
      bindsym $mod+Shift+f exec "${homeDirectory}/.dotfiles/bin/mosh-lithium"
      # start dmenu (a program launcher)
      bindsym $mod+d exec "${pkgs.bemenu}/bin/bemenu-run" -c --hp '10' --fn 'Iosevka Fixed 16' -p 'bemenu%' | swaymsg exec --

      exec --no-startup-id {
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
    target = "sway/config.d/launchers";
  };
  swayColors = {
    enable = isDebian;
    source = ../../sway/config.d/colors;
    target = "sway/config.d/colors";
  };
  pyPoetryDebian = {
    enable = isDebian;
    text = ''
      cache-dir = "${xdgCacheHome}/pypoetry"
    '';
    target = "pypoetry/config.toml";
  };
  gdb = {
    enable = isDebian;
    source = ../../gdb/gdbinit;
    target = "gdb/gdbinit";
  };
  alacrittyTheme = {
    enable = isDarwin;
    source = ../../selenized/terminals/alacritty/selenized-light.yml;
    target = "alacritty/selenized-light.yml";
  };
  aerospace = {
    enable = isDarwin;
    source = ../../aerospace/aerospace.toml;
    target = "aerospace/aerospace.toml";
  };
}
