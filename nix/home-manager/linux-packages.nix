{ pkgs, ... }:
{
  home.packages = [
    # GUIs
    pkgs.keepassxc

    # Debugger
    pkgs.gdb

    # Nix
    # Not available on Darwin
    pkgs.cntr

    # Networking
    # Marked broken
    pkgs.mitmproxy

    # Remote desktop
    pkgs.tigervnc

    # Build tools
    pkgs.gnumake
  ];
}
