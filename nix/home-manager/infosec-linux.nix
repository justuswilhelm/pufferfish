# Infosec related packages on Linux
{ pkgs, ... }:
{
  home.packages = [
    # Exploits
    # =======
    pkgs.metasploit
    pkgs.armitage

    # RPC
    # ===
    pkgs.rpcbind

    # Cracking
    # ========
    (pkgs.python3Packages.patator.override {
      # odpic causes issues on Darwin
      cx-oracle = null;
    })
  ];
}