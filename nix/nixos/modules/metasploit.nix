{ pkgs, ... }:
{
  users.groups.msf = { };
  users.users.msf = {
    description = "user for Metasploit db";
    group = "msf";
    isSystemUser = true;
  };

  environment.systemPackages = [
    pkgs.metasploit
  ];

  # DB for Metasploit
  # Inside Metasplot, run
  # msfdb init --connection-string postgresql://msf@msf?host=/var/run/postgresql
  # db_connect msf@localhost/msf
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "msf" ];
    ensureUsers = [{
      name = "msf";
      ensureDBOwnership = true;
    }];
    authentication = ''
      local msf all peer map=msf
      host msf all 127.0.0.1/32 trust
    '';
    identMap = ''
      msf /.+ msf
    '';
  };
}
