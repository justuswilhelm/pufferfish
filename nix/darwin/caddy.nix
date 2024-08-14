{ config, pkgs, ... }:
let
  caddy = pkgs.caddy;
  logPath = "/var/log/caddy";
in
{
  users.groups.caddy = {
    gid = 602;
  };
  users.users.caddy = {
    createHome = false;
    description = "Caddy";
    gid = 602;
    uid = 52;
    isHidden = true;
  };
  users.knownGroups = [
    "caddy"
  ];
  users.knownUsers = [
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
    };
  };

  security.pki.certificateFiles = [
    "/etc/caddy/lithium-ca.crt"
  ];
  system.activationScripts.postActivation = {
    text = ''
      set -e
      set -o pipefail
      mkdir -p /var/log/caddy
      mkdir -p /etc/caddy/certs
      chown -R caddy:caddy /etc/caddy/certs /var/log/caddy
      chmod 0400 /etc/caddy/certs/*
    '';
  };
}
