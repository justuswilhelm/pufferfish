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

    pkgs.tigervnc
  ];
}
