# Infosec related packages and config
{ pkgs, ... }:
{
  home.packages = [
    # Reverse engineering
    # ===================
    (
      pkgs.symlinkJoin {
        name = "ghidra";
        paths = [ pkgs.ghidra ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/ghidra --set _JAVA_AWT_WM_NONREPARENTING 1
        '';
      }
    )
    (
      pkgs.symlinkJoin {
        name = "radare2";
        paths = [
          pkgs.radare2
          pkgs.meson
          pkgs.ninja
        ];
      }
    )

    # Binary
    # ======
    pkgs.programmer-calculator
    pkgs.xxd

    # Networking
    # ==========
    pkgs.inetutils
    pkgs.whois
    pkgs.nmap

    # Network utils
    # =============
    pkgs.socat
    pkgs.tunnelto
    pkgs.netcat-gnu

    # DNS
    # ===
    pkgs.dig

    # Packet sniffing
    # ===============
    pkgs.tcpdump

    # Web scanning
    # ============
    pkgs.gobuster
    # similar to gobuster, but in rust and has recursive mode
    pkgs.feroxbuster
    pkgs.nikto
    # https://github.com/epsylon/xsser
    pkgs.xsser
    # https://github.com/hahwul/dalfox
    pkgs.dalfox
    pkgs.whatweb
    pkgs.commix

    # Cracking
    # ========
    pkgs.thc-hydra
    pkgs.john
    pkgs.hashcat

    # Files
    # =====
    pkgs.rsync
    pkgs.ncftp

    # Forensics
    # =========
    pkgs.exiftool

    # Samba
    # =====
    pkgs.samba
    pkgs.python3Packages.impacket

    # WebDAV
    # ======
    pkgs.davtest

    # SSH
    # ===
    pkgs.sshpass

    # Databases
    # =========
    pkgs.sqlmap
    pkgs.mongosh
    pkgs.postgresql
    pkgs.mysql84

    # Cryptography
    # ============
    (pkgs.python3.withPackages (
      python-pkgs: with python-pkgs; [
        scipy
        jupyter
        sympy
        requests
        pandas
        cryptography
      ]
    ))

    # PHP
    # ===
    pkgs.php
  ];
}
