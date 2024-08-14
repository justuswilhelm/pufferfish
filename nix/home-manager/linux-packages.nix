{ pkgs, ... }:
{
  home.packages = [
    # Compositor
    # This won't load because of some OpenGL issue
    # pkgs.sway
    # Swaylock doesn't work well.
    # pkgs.swaylock
    # Disabling this just to be safe
    # pkgs.swayidle
    pkgs.bemenu
    pkgs.grim
    pkgs.slurp

    # GUIs
    pkgs.keepassxc
    pkgs.tor-browser

    # Debugger
    pkgs.gdb

    # Nix
    # Not available on Darwin
    pkgs.cntr

    # Networking
    # Marked broken
    pkgs.mitmproxy
  ];
}
