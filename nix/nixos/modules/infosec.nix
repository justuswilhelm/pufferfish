{ ... }:
let
  user = "delighted-negotiate-catchy";
in
{
  # For reverse shell with openvpn
  networking.firewall.allowedTCPPorts = [ 4444 ];

  users.groups.${user} = { };
  users.users.${user} = {
    description = "random user for pentesting";
    group = user;
    isNormalUser = true;
    home = "/tmp/${user}";
  };
  users.groups.msf = { };
  users.users.msf = {
    description = "user for Metasploit db";
    group = "msf";
    isSystemUser = true;
  };

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
  # Thx internet
  # https://unix.stackexchange.com/a/692227
  environment.etc."samba/smb.conf".text = ''
    client min protocol = CORE
    client max protocol = SMB3
  '';

  programs.wireshark.enable = true;
  # If USB sniffing required:
  # https://discourse.nixos.org/t/using-wireshark-as-an-unprivileged-user-to-analyze-usb-traffic/38011
}
