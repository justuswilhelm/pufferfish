# Infosec related packages on Linux
{ pkgs, ... }:
{
  home.packages = [
    # Reverse engineering
    # ===================
    pkgs.python3Packages.ropper
    pkgs.flashrom

    # Exploits
    # =======
    pkgs.metasploit

    # RPC
    # ===
    pkgs.rpcbind

    # File transfer
    # =============
    pkgs.cadaver
    pkgs.rs-tftpd

    # Networking
    # ==========
    pkgs.netexec
    pkgs.openssl
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
    pkgs.netexec
    pkgs.bloodhound
    pkgs.bloodhound-py
    pkgs.openldap

    # Debugger
    # ========
    (
      pkgs.symlinkJoin {
        name = "gdb-with-python-packages";
        paths = [ pkgs.gdb ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/gdb --set PYTHONPATH ${pkgs.python3}/${pkgs.python3.sitePackages}:${pkgs.ghidra}/lib/ghidra/Ghidra/Debug/Debugger-agent-gdb/pypkg/src:${pkgs.ghidra}/lib/ghidra/Ghidra/Debug/Debugger-rmi-trace/pypkg/src

        '';
      }
    )
  ];
}
