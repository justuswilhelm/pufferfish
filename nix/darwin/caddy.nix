{ config, pkgs, ... }:
let
  caddy = pkgs.caddy;
  logPath = "/var/log/caddy";
  statePath = "/var/lib/caddy";
  caStatePath = "/var/lib/lithium-ca";
in
{
  users.groups.lithium-ca = { gid = 1101; };
  users.users.lithium-ca = {
    description = "Lithium CA";
    home = caStatePath;
    gid = 1101;
    uid = 1101;
    isHidden = true;
    createHome = false;
  };

  users.groups.caddy = { gid = 602; };
  users.users.caddy = {
    home = statePath;
    description = "Caddy";
    gid = 602;
    uid = 52;
    isHidden = true;
  };

  users.knownGroups = [ "lithium-ca" "caddy" ];
  users.knownUsers = [ "lithium-ca" "caddy" ];

  environment.etc."caddy/Caddyfile".source = ./Caddyfile;
  environment.systemPackages = [ caddy ];

  launchd.daemons.caddy = {
    command = "${caddy}/bin/caddy run --config /etc/caddy/Caddyfile";
    serviceConfig = {
      KeepAlive = true;
      StandardErrorPath = "${logPath}/caddy.stderr.log";
      UserName = "caddy";
      GroupName = "caddy";
    };
  };

  # This is a bit flaky, sometimes this cert is not included in
  # /etc/ssl/certs/ca-ceriticates.crt
  security.pki.certificateFiles = [ ../lithium-ca.crt ];

  system.activationScripts.preActivation = {
    text = ''
      mkdir -p ${logPath} ${statePath} ${caStatePath} ${caStatePath}/signed
      mkdir -p -m700 ${statePath}/secrets ${caStatePath}/secrets
      chown -R caddy:caddy ${logPath} ${statePath}
      chown -R lithium-ca:lithium-ca ${caStatePath}
      chmod -R go= ${statePath}/secrets
      chmod -R go= ${caStatePath}/secrets
    '';
  };

  # Restart caddy
  system.activationScripts.postActivation = {
    text = ''
      caddy validate --config /etc/caddy/Caddyfile

      echo "Restarting caddy"
      launchctl kickstart -k system/${config.launchd.labelPrefix}.caddy
    '';
  };
}
