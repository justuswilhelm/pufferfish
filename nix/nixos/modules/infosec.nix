{ ... }:
let
  user = "delighted-negotiate-catchy";
in
{
  # For reverse shell with openvpn
  networking.firewall.allowedTCPPorts = [ 4444 ];

  users.groups.${user} = {};
  users.users.${user} = {
    description = "random user for pentesting";
    group = user;
    isNormalUser = true;
    home = "/tmp/${user}";
  };
}
