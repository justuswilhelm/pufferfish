# Contains just sway launcher config now
{ lib, config, pkgs, specialArgs, osConfig, ... }:
let
  # We need to convince macOS to open this as a proper app, not as a child of
  # aerospace
  # TODO use cfg.home.homeDirectory
  alacrittyApp = "/Users/${specialArgs.name}/Applications/Home Manager Apps/Alacritty.app";
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
  newFirefoxWindow = ''exec-and-forget if pgrep -U $USER firefox; then '${firefox}' --new-window; else open -a '${firefoxApp}'; fi'';
  # Try copying this to your clipboard: https://www.example.com
  openClipboardInFirefox = ''exec-and-forget open -a '${firefoxApp}' "$(pbpaste)"'';
  prefix = "cmd-alt";
  config = {
    # Reference: https://github.com/i3/i3/blob/next/etc/config
    mode.main.binding = {
      # change focus
      "${prefix}-h" = "focus left";
      "${prefix}-j" = "focus down";
      "${prefix}-k" = "focus up";
      "${prefix}-l" = "focus right";

      # move focused window
      "${prefix}-shift-h" = "move left";
      "${prefix}-shift-j" = "move down";
      "${prefix}-shift-k" = "move up";
      "${prefix}-shift-l" = "move right";

      # split in horizontal orientation
      # cmd-alt-b = 'split horizontal'

      # split in vertical orientation
      # cmd-alt-v = 'split vertical'

      # enter fullscreen mode for the focused container
      "${prefix}-f" = "fullscreen";

      # change container layout (stacked, tabbed, toggle split)
      # 'layout stacking' in i3
      "${prefix}-s" = "layout v_accordion";
      # 'layout tabbed' in i3
      "${prefix}-w" = "layout h_accordion";
      # 'layout toggle split' in i3
      "${prefix}-e" = "layout tiles horizontal vertical";

      # toggle tiling / floating
      # 'floating toggle' in i3
      "${prefix}-shift-space" = "layout floating tiling";

      # Not supported, because this command is redundant in AeroSpace mental model.
      # See: https://nikitabobko.github.io/AeroSpace/guide.html#floating-windows
      #alt-space = 'focus toggle_tiling_floating'

      # `focus parent`/`focus child` are not yet supported, and it's not clear whether they
      # should be supported at all https://github.com/nikitabobko/AeroSpace/issues/5
      # alt-a = 'focus parent'

      # switch to workspace
      "${prefix}-1" = "workspace 1";
      "${prefix}-2" = "workspace 2";
      "${prefix}-3" = "workspace 3";
      "${prefix}-4" = "workspace 4";
      "${prefix}-5" = "workspace 5";
      "${prefix}-6" = "workspace 6";
      "${prefix}-7" = "workspace 7";
      "${prefix}-8" = "workspace 8";
      "${prefix}-9" = "workspace 9";
      "${prefix}-0" = "workspace 10";

      # move focused container to workspace
      "${prefix}-shift-1" = "move-node-to-workspace 1";
      "${prefix}-shift-2" = "move-node-to-workspace 2";
      "${prefix}-shift-3" = "move-node-to-workspace 3";
      "${prefix}-shift-4" = "move-node-to-workspace 4";
      "${prefix}-shift-5" = "move-node-to-workspace 5";
      "${prefix}-shift-6" = "move-node-to-workspace 6";
      "${prefix}-shift-7" = "move-node-to-workspace 7";
      "${prefix}-shift-8" = "move-node-to-workspace 8";
      "${prefix}-shift-9" = "move-node-to-workspace 9";
      "${prefix}-shift-0" = "move-node-to-workspace 10";

      # reload the configuration file
      "${prefix}-shift-r" = "reload-config";

      # resize window (you can also use the mouse for that)
      "${prefix}-enter" = openAlacritty fish;
      "${prefix}-shift-enter" = newFirefoxWindow;
      "${prefix}-shift-n" = openAlacritty "${fish} -i -c open-in-finder";
      # Dotfiles
      "${prefix}-shift-m" = [
        "workspace 4"
        (openAlacritty "${fish} -l -c manage-dotfiles")
      ];
      # Time tracking
      "${prefix}-shift-f" = [
        "workspace 3"
        (openAlacritty "${fish} -l -c tomato")
      ];
      # Cmus
      "${prefix}-shift-t" = [
        "workspace 3"
        (openAlacritty "${fish} -l -c t-cmus")
      ];
      # Anki
      "${prefix}-shift-a" = [
        "workspace 1"
        "exec-and-forget open -a Anki.app"
      ];
      # Blog
      "${prefix}-shift-b" = [
        "workspace 1"
        (openAlacritty "${fish} -l -c blog")
      ];
      # Open URL
      "${prefix}-shift-p" = [
        openClipboardInFirefox
      ];
      "${prefix}-r" = "mode resize";
    };
    mode.resize.binding = {
      # These bindings trigger as soon as you enter the resize mode
      # Pressing left will shrink the window’s width.
      # Pressing right will grow the window’s width.
      # Pressing up will shrink the window’s height.
      # Pressing down will grow the window’s height.
      h = "resize width -50";
      j = "resize height +50";
      k = "resize height -50";
      l = "resize width +50";

      # back to normal
      cmd-alt-r = "mode main";
    };
    # https://nikitabobko.github.io/AeroSpace/guide#callbacks
    on-window-detected = [
      {
        "if".app-id = "com.apple.mail";
        run = [ "move-node-to-workspace 5" ];
      }
      {
        "if".app-id = "org.mozilla.thunderbird";
        run = [ "move-node-to-workspace 5" ];
      }
      {
        "if".app-id = "org.mozilla.thunderbird";
        "if".window-title-regex-substring = "Sending Message";
        run = [ "layout floating" ];
      }
      {
        "if".app-id = "com.apple.iCal";
        run = [ "move-node-to-workspace 6" ];
      }
      {
        "if".app-id = "org.libreoffice.script";
        "if".window-title-regex-substring = lib.strings.concatMapStringsSep
          "|"
          (s: "(${s})")
          [
            "(Format|Insert) Cells"
            "Hyperlink"
            "Save Document"
            "Delete Contents"
            "Rename Sheet"
            "Confirmation"
            "Page Style: .+"
            "Chart (Area|Type|Wall)"
            "Data (Table|Ranges)"
            "(X|Y) Axis"
            "Axes"
            "Legend"
            "Titles"
            "Find And Replace"
          ];
        run = [ "layout floating" ];
      }
      {
        "if".app-id = "org.libreoffice.script";
        run = [ "layout tiling" ];
      }
      {
        "if".app-id = "com.utmapp.UTM";
        run = [ "layout floating" ];
      }
    ];
  };
in
{
  services.aerospace.enable = true;
  services.aerospace.settings = config;
}
