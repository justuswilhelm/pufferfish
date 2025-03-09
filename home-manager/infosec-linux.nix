# Infosec related packages on Linux
{ pkgs, ... }:
{
  home.packages = [
    # Reverse engineering
    # ===================
    pkgs.python3Packages.ropper
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
        name = "gdb-with-python-packages";
        paths = [ pkgs.gdb ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild =
          let
            python3 = pkgs.python3.withPackages (p: with p; [ protobuf psutil ]);
          in
          ''
            wrapProgram $out/bin/gdb --set PYTHONPATH ${python3}/${python3.sitePackages}:${pkgs.ghidra}/lib/ghidra/Ghidra/Debug/Debugger-agent-gdb/pypkg/src:${pkgs.ghidra}/lib/ghidra/Ghidra/Debug/Debugger-rmi-trace/pypkg/src

          '';
      }
    )

    # Exploits
    # =======
    pkgs.metasploit
    pkgs.radamsa

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
    pkgs.wireshark
    # For clock skews
    pkgs.libfaketime
    pkgs.zap

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
    # pkgs.bloodhound
    # pkgs.bloodhound-py
    pkgs.openldap

    # Debugger
    # ========
  ];
}
