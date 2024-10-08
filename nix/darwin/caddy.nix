{ config, pkgs, ... }:
let
  caddy = pkgs.caddy;
  logPath = "/var/log/caddy";
in
{
  users.groups.lithium-ca = {
    gid = 1101;
  };
  users.users.lithium-ca = {
    description = "Lithium CA";
    gid = 1101;
    uid = 1101;
    isHidden = true;
    createHome = false;
  };
  users.groups.caddy = {
    gid = 602;
  };
  users.users.caddy = {
    home = "/var/caddy/home";
    description = "Caddy";
    gid = 602;
    uid = 52;
    isHidden = true;
  };
  users.knownGroups = [
    "lithium-ca"
    "caddy"
  ];
  users.knownUsers = [
    "lithium-ca"
    "caddy"
  ];
  environment.etc.caddyfile = {
    source = ./Caddyfile;
    target = "caddy/Caddyfile";
  };
  environment.systemPackages = [
    caddy
  ];

  launchd.daemons.caddy = {
    command = "${caddy}/bin/caddy run --config /etc/caddy/Caddyfile";
    serviceConfig = {
      KeepAlive = true;
      StandardOutPath = "${logPath}/caddy.stdout.log";
      StandardErrorPath = "${logPath}/caddy.stderr.log";
      UserName = "caddy";
      GroupName = "caddy";
    };
  };

  # This is a bit flaky, sometimes this cert is not included in
  # /etc/ssl/certs/ca-ceriticates.crt
  security.pki.certificateFiles = [
    ../lithium-ca.crt
  ];
  system.activationScripts.postActivation = {
    text = ''
      set -e
      set -o pipefail
      mkdir -p /var/log/caddy
      mkdir -p /var/caddy/home
      caddy validate --config /etc/caddy/Caddyfile
    '';
  };
}
