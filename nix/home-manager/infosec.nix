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
    pkgs.netcat-gnu
    pkgs.inetutils
    pkgs.whois
    pkgs.nmap
    pkgs.dig

    # Packet sniffing
    # ===============
    pkgs.tcpdump

    # Web scanning
    # ============
    pkgs.gobuster
    pkgs.nikto

    # Cracking
    # ========
    (pkgs.python311Packages.patator.override {
      # odpic causes issues on Darwin
      cx-oracle = null;
    })
    pkgs.thc-hydra
    pkgs.john
    pkgs.hashcat

    # Files
    # =====
    pkgs.rsync
    pkgs.ncftp

    # Samba
    # =====
    pkgs.samba
    pkgs.python3Packages.impacket

    # SSH
    # ===
    pkgs.sshpass

    # Databases
    # =========
    pkgs.sqlmap
    pkgs.mongosh
    pkgs.postgresql
  ];
}
