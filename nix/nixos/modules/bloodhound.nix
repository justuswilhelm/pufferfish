{ pkgs, ... }:
{
  # Bloodhound
  environment.systemPackages = [
    pkgs.bloodhound
    pkgs.bloodhound-py
  ];
  services.neo4j = {
    enable = true;
    http.enable = false;
    https.enable = false;
    # This is needed:
    # extraServerConfig = ''
    #   dbms.security.auth_enabled=false
    # '';
    # Ideally it would just offer domain sockets...
    bolt = {
      listenAddress = "127.0.0.1:7687";
      tlsLevel = "DISABLED";
    };
  };
}
