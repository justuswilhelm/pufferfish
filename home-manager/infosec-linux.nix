# Infosec related packages on Linux
{ pkgs, ... }:
{
  home.packages = [
    # Reverse engineering
    # ===================
    pkgs.nasm
    pkgs.python3Packages.ropper
    pkgs.flashrom
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
    # For clock skews
    pkgs.libfaketime

    # Web
    # ===
    pkgs.zap
    pkgs.ungoogled-chromium

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
    pkgs.openldap

    # Debugger
    # ========
  ];
}
