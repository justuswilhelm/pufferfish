{ pkgs, ... }:
let
  anki-sync-serer = pkgs.anki-sync-server;
  logPath = "/var/log/anki-sync-server";
in
{
  users.groups.anki-sync-server = {
    gid = 601;
  };
  users.users.anki-sync-server = {
    createHome = false;
    description = "Anki-sync-server user";
    gid = 601;
    uid = 51;
    isHidden = true;
  };
  users.knownGroups = [
    "anki-sync-server"
  ];
  users.knownUsers = [
    "anki-sync-server"
  ];
  launchd.daemons.anki-sync-server = {
    script = ''
      SYNC_USER1="$(cat /etc/anki-sync-server/sync_user1)"
      export SYNC_USER1
      # https://docs.ankiweb.net/sync-server.html#hashed-passwords
      # TODO
      # export PASSWORDS_HASHED=1
      #
      # Type ".help" for more information.
      # > const pbkdf2 = require("@phc/pbkdf2");
      # console.log(await pbkdf2.hash("password");
      # undefined
      exec ${anki-sync-serer}/bin/anki-sync-server
    '';
    serviceConfig = {
      KeepAlive = true;
      StandardOutPath = "${logPath}/anki-sync-server.stdout.log";
      StandardErrorPath = "${logPath}/anki-sync-server.stderr.log";
      UserName = "anki-sync-server";
      EnvironmentVariables = {
        SYNC_HOST = "127.0.0.1";
        SYNC_PORT = "18090";
        SYNC_BASE = "/var/anki-sync-server";
      };
    };
  };
  system.activationScripts.postActivation = {
    text = ''
      set -e
      set -o pipefail
      mkdir -p /var/log/anki-sync-server
      mkdir -p /var/anki-sync-server
      mkdir -p /etc/anki-sync-server
      chown -R anki-sync-server:anki-sync-server /var/anki-sync-server /etc/anki-sync-server /var/log/anki-sync-server
      chmod 0400 /etc/anki-sync-server/sync_user1
    '';
  };
}
