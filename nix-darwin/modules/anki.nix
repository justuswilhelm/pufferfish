# TODO add password hashing
{ lib, pkgs, config, ... }:
let
  anki-sync-server = pkgs.anki-sync-server;
  username = "anki-sync-server";
  groupname = "anki-sync-server";
  home = "/var/lib/${username}";
  statePath = "${home}/sync-base";
  usersPath = "${home}/users";
  syncUser1 = "${usersPath}/sync_user_1";
  logPath = "/var/log/${username}";
  host = "localhost";
  port = 18090;
  caddyHost = "lithium.local";
  caddyPort = 10101;
  caddyConfig = ''
    # Anki
    https://${caddyHost}:${toString caddyPort} {
      import certs

      reverse_proxy ${host}:${toString port}

      log {
        format console
        output file ${config.services.caddy.logPath}/anki.log
      }
    }
  '';
in
{
  users.groups.anki-sync-server = {
    gid = 601;
  };
  users.users.anki-sync-server = {
    inherit home;
    description = "Anki-sync-server user";
    gid = 601;
    uid = 51;
    isHidden = true;
  };
  users.knownGroups = [ username ];
  users.knownUsers = [ groupname ];

  services.newsyslog.modules.anki = {
    "${logPath}/anki-sync-server.stdout.log" = {
      owner = username;
      group = groupname;
      mode = "640";
      count = 10;
      size = "*";
      when = "$D0";
      flags = "J";
    };
    "${logPath}/anki-sync-server.stderr.log" = {
      owner = username;
      group = groupname;
      mode = "640";
      count = 10;
      size = "*";
      when = "$D0";
      flags = "J";
    };
  };

  services.nagios.objectDefs =
    let
      healthEndpoint = "/health";
      ankiNagios = pkgs.writeText "anki.cfg" ''
        define service {
            use generic-service
            host_name ${caddyHost}
            service_description anki-sync-server
            display_name Anki Sync Server (Caddy)
            check_command check_curl!-p ${toString caddyPort} --ssl=1.3 --url=${healthEndpoint} --expect='HTTP/2 200'
        }

        define service {
            use generic-service
            host_name ${host}
            service_description anki-sync-server
            display_name Anki Sync Server (localhost)
            check_command check_curl!-p ${toString port} --url=${healthEndpoint} --expect='HTTP/1.1 200'
        }
      '';
    in
    lib.optional config.services.nagios.enable ankiNagios;
  services.caddy.extraConfig = caddyConfig;

  launchd.daemons.anki-sync-server = {
    path = [ pkgs.coreutils anki-sync-server ];
    script = ''
      mkdir -p ${statePath}
      mkdir -p ${usersPath}

      SYNC_USER1="$(cat ${syncUser1})"
      export SYNC_USER1
      # https://docs.ankiweb.net/sync-server.html#hashed-passwords
      # TODO
      # export PASSWORDS_HASHED=1
      #
      # Type ".help" for more information.
      # > const pbkdf2 = require("@phc/pbkdf2");
      # console.log(await pbkdf2.hash("password");
      # undefined
      exec anki-sync-server
    '';
    serviceConfig = {
      KeepAlive = true;
      # Anki doesn't log to stderr
      StandardOutPath = "${logPath}/anki-sync-server.log";
      UserName = username;
      EnvironmentVariables = {
        SYNC_HOST = "127.0.0.1";
        SYNC_PORT = toString port;
        SYNC_BASE = statePath;
      };
    };
  };
  system.activationScripts.preActivation = {
    text = ''
      mkdir -pv ${home} ${logPath}

      chown -R ${username}:${groupname} ${home} ${logPath}
      chmod -R go= ${home}
    '';
  };
}
