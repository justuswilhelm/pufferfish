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
    home = "/var/caddy/home";
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
    "/etc/caddy/certs/lithium-ca.crt"
  ];
  system.activationScripts.postActivation = {
    text = ''
      set -e
      set -o pipefail
      mkdir -p /var/log/caddy
      mkdir -p /etc/caddy/certs
      mkdir -p /var/caddy/home
      chown -R caddy:caddy /etc/caddy/certs /var/log/caddy /var/caddy/home
      chmod 0400 /etc/caddy/certs/*
      chmod 0444 /etc/caddy/certs/lithium-ca.crt
      caddy validate --config /etc/caddy/Caddyfile
    '';
  };
}
