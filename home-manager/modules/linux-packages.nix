{ pkgs, ... }:
{
  home.packages = [
    # File management
    # ===============
    pkgs.ncdu
    pkgs.file

    # Nix
    # ===
    # Not available on Darwin
    pkgs.cntr

    # Remote desktop
    # ==============

    # TTY tools
    # =========
    pkgs.tio

    # System tools
    # ============
    pkgs.pciutils
    pkgs.usbutils

    # Build tools
    # ===========
  ];
}
