# Infosec related packages and config
{ pkgs, ... }:
let
  requestbin = pkgs.buildGoModule rec {
    name = "requestbin";
    version = "unreleased";
    src = pkgs.fetchFromGitHub {
      owner = "fiatjaf";
      repo = "requestbin";
      rev = "47d7554";
      sha256 = "sha256-Y2eyeiZfdqQjByiesi6TMirHR7GiXVyA8UsNBjEMvrE=";
    };
    vendorHash = null;
  };
in
{
  home.packages = [
    # Binary
    # ======
    pkgs.programmer-calculator
    pkgs.xxd
    pkgs.binwalk
    pkgs.nasm

    # Networking
    # ==========
    pkgs.inetutils
    pkgs.whois
    pkgs.nmap
    pkgs.arp-scan

    # Exploits
    # ========
    pkgs.exploitdb

    # Network utils
    # =============
    pkgs.socat
    pkgs.tunnelto
    pkgs.netcat-gnu
    requestbin

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
    (pkgs.sqlmap.overridePythonAttrs (old: {
      dependencies = (old.dependencies or [ ]) ++ [
        pkgs.python3Packages.websocket-client
      ];
    }))
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
        pycrypto
        pwntools
        # Shodan hashes
        mmh3
      ]
    ))
    pkgs.jwt-cli

    # PHP
    # ===
    pkgs.php
  ];
}
