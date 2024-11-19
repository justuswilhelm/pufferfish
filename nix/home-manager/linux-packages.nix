{ pkgs, ... }:
{
  home.packages = [
    # Communication
    # =============
    pkgs.signal-desktop
    # File management
    # ===============
    pkgs.ncdu
    pkgs.file

    # GUIs
    # ====
    pkgs.keepassxc

    # Debugger
    # ========
    pkgs.gdb

    # Nix
    # ===
    # Not available on Darwin
    pkgs.cntr

    # Networking
    # ==========
    pkgs.mitmproxy

    # Remote desktop
    # ==============
    pkgs.tigervnc

    # Build tools
    # ===========
    pkgs.gcc
    pkgs.gnumake
  ];
}
