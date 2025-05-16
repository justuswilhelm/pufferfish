{ config, lib, pkgs, ... }:
let
  radicaleState = "/var/lib/radicale";
  logPath = "/var/log/radicale";

  radicale = pkgs.radicale;
  radicaleConfig = pkgs.writeText "config" (lib.generators.toINI { } {
    server = {
      hosts = "127.0.0.1:18110";
    };

    auth = {
      type = "htpasswd";
      htpasswd_filename = "${radicaleState}/users";
      htpasswd_encryption = "bcrypt";
    };

    storage = {
      filesystem_folder = "${radicaleState}/collections";
    };
  });

  caddyConfig = ''
    # Radicale
    https://lithium.local:10102 {
      import certs

      reverse_proxy localhost:18110

      log {
        format console
        output file ${config.services.caddy.logPath}/radicale.log
      }
    }
  '';
in
{
  users.groups.radicale = { gid = 1020; };
  users.users.radicale = {
    description = "Radicale User";
    gid = 1020;
    uid = 1020;
    isHidden = true;
  };
  users.knownGroups = [ "radicale" ];
  users.knownUsers = [ "radicale" ];

  environment.etc."radicale/config".source = radicaleConfig;

  services.newsyslog.modules.radicale = {
    "${logPath}/radicale.stdout.log" = {
      owner = "radicale";
      group = "radicale";
      mode = "640";
      count = 10;
      size = "*";
      when = "$D0";
      flags = "J";
    };
    "${logPath}/radicale.stderr.log" = {
      owner = "radicale";
      group = "radicale";
      mode = "640";
      count = 10;
      size = "*";
      when = "$D0";
      flags = "J";
    };
  };

  services.caddy.extraConfig = caddyConfig;

  environment.systemPackages = [ radicale ];
  launchd.daemons.radicale = {
    command = "${radicale}/bin/radicale";
    serviceConfig = {
      KeepAlive = true;
      StandardOutPath = "${logPath}/radicale.stdout.log";
      StandardErrorPath = "${logPath}/radicale.stderr.log";
      UserName = "radicale";
      GroupName = "radicale";
    };
  };
  system.activationScripts.postActivation = {
    text = ''
      echo "Ensuring radicale directories exist"
      sudo mkdir -p ${radicaleState} ${logPath}
      sudo chown radicale:radicale ${radicaleState} ${logPath}
      sudo chmod go= ${radicaleState}
      echo "Restarting radicale"
      launchctl kickstart -k system/${config.launchd.labelPrefix}.radicale
    '';
  };
}

