{ pkgs, ... }:
let
  user = "delighted-negotiate-catchy";
in
{
  networking.firewall.logRefusedPackets = true;
  networking.firewall.logRefusedConnections = true;

  # TODO copy the below settings to other interfaces if needed
  # Hack the box stuff
  networking.firewall.allowedTCPPorts = [
    4444
  ];
  networking.firewall.interfaces.tun0.allowedTCPPorts = [
    # SMB
    445
    # For reverse shell with openvpn
    4444
    # Another rev shell port
    4445
    # For http server
    8080
  ];
  networking.firewall.interfaces.tun0.allowedUDPPorts = [
    # For tftp
    4444
  ];

  # For fake ISP hax0ring
  networking.firewall.interfaces.ppp0.allowedTCPPorts = [
    # HTTP
    80
  ];
  networking.firewall.interfaces.ppp0.allowedUDPPorts = [
    # For DNS
    53
  ];

  # Add overrides
  networking.hosts = {
    # Ex. "10.10.10.1" = [ "domain1.tld" "domain2.tld" ];
  };

  users.groups.${user} = { };
  users.users.${user} = {
    description = "random user for pentesting";
    group = user;
    isNormalUser = true;
    home = "/tmp/${user}";
  };
  # Thx internet
  # https://unix.stackexchange.com/a/692227
  environment.etc."samba/smb.conf".text = ''
    client min protocol = CORE
    client max protocol = SMB3
  '';

  # If USB sniffing required:
  # https://discourse.nixos.org/t/using-wireshark-as-an-unprivileged-user-to-analyze-usb-traffic/38011
}
