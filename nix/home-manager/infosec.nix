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
    pkgs.python3Packages.ropper

    # Binary
    # ======
    pkgs.programmer-calculator
    pkgs.xxd

    # Networking
    # ==========
    pkgs.inetutils
    pkgs.whois
    pkgs.nmap

    # Exploits
    # ========
    pkgs.exploitdb

    # Network utils
    # =============
    pkgs.socat
    pkgs.tunnelto
    pkgs.netcat-gnu

    # DNS
    # ===
    pkgs.dig
    pkgs.dnsrecon

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
    # pw hashing, e.g., nettle-pbkdf2
    pkgs.nettle

    # Files
    # =====
    pkgs.rsync
    pkgs.ncftp

    # Forensics
    # =========
    pkgs.exiftool

    # Windows (RPC, SMB, LDAP, Kerberos)
    # =====
    pkgs.samba
    # pkgs.python3Packages.impacket
    pkgs.kerbrute
    pkgs.enum4linux
    pkgs.enum4linux-ng
    pkgs.responder
    pkgs.coercer

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
    pkgs.pysqlrecon
    pkgs.sqsh

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
        nclib
        impacket
      ]
    ))
    pkgs.jwt-cli

    # PHP
    # ===
    pkgs.php
  ];
}
