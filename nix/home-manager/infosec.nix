# Infosec related packages and config
{ pkgs, ... }:
{
  home.packages = [
    # Reverse engineering
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
    pkgs.programmer-calculator
    pkgs.xxd

    # Networking
    pkgs.netcat-gnu
    pkgs.inetutils
    pkgs.whois
    pkgs.nmap

    # Web scanning
    pkgs.thc-hydra
    pkgs.gobuster
    pkgs.nikto

    # Databases
    pkgs.sqlmap
    pkgs.mongosh
  ];
}
