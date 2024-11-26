# Infosec related packages on Linux
{ pkgs, ... }:
{
  home.packages = [
    # Reverse engineering
    # ===================
    pkgs.python3Packages.ropper

    # Exploits
    # =======
    pkgs.metasploit

    # RPC
    # ===
    pkgs.rpcbind

    # WebDAV
    # ======
    pkgs.cadaver

    # Networking
    # ==========
    pkgs.netexec
    pkgs.openssl
    pkgs.wireshark
    # For clock skews
    pkgs.libfaketime

    # SNMP
    # ====
    pkgs.net-snmp
    pkgs.snmpcheck

    # NTP
    # ===
    pkgs.ntp

    # Cracking
    # ========
    (pkgs.python3Packages.patator.override {
      # odpic causes issues on Darwin
      cx-oracle = null;
    })

    # Windows
    # =======
    pkgs.crackmapexec
    pkgs.bloodhound
    pkgs.bloodhound-py
    pkgs.openldap
  ];
}
