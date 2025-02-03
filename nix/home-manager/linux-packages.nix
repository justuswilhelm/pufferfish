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

    # Nix
    # ===
    # Not available on Darwin
    pkgs.cntr

    # Remote desktop
    # ==============
    pkgs.tigervnc

    # TTY tools
    # =========
    pkgs.tio

    # System tools
    # ============
    pkgs.pciutils
    pkgs.usbutils

    # Build tools
    # ===========
    pkgs.gcc
    pkgs.gnumake
  ];
}
