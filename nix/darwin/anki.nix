# TODO add password hashing
{ pkgs, ... }:
let
  anki-sync-server = pkgs.anki-sync-server;
  # TODO
  # homePath = "/var/lib/anki-sync-server";
  # TODO make this
  # statePath = "${homePath}/sync";
  statePath = "/var/anki-sync-server";
  logPath = "/var/log/anki-sync-server";
  # TODO make this
  # syncUser1 = "${statePath}/users/sync_user_1";
  syncUser1 = "/etc/anki-sync-server/sync_user1";
in
{
  users.groups.anki-sync-server = {
    gid = 601;
  };
  users.users.anki-sync-server = {
    # TODO remove createHome and add home path
    # inherit homePath;
    createHome = false;
    description = "Anki-sync-server user";
    gid = 601;
    uid = 51;
    isHidden = true;
  };
  users.knownGroups = [ "anki-sync-server" ];
  users.knownUsers = [ "anki-sync-server" ];

  launchd.daemons.anki-sync-server = {
    path = [ anki-sync-server ];
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
      exec anki-sync-server
    '';
    serviceConfig = {
      KeepAlive = true;
      StandardOutPath = "${logPath}/anki-sync-server.stdout.log";
      StandardErrorPath = "${logPath}/anki-sync-server.stderr.log";
      UserName = "anki-sync-server";
      EnvironmentVariables = {
        SYNC_HOST = "127.0.0.1";
        SYNC_PORT = "18090";
        SYNC_BASE = statePath;
      };
    };
  };
  system.activationScripts.preActivation = {
    text = ''
      mkdir -vp ${logPath}
      mkdir -vp ${statePath}
      chown -R anki-sync-server:anki-sync-server ${statePath} /etc/anki-sync-server ${logPath}

      mkdir -vp /etc/anki-sync-server
      chmod -v 0400 ${syncUser1}
    '';
  };
}
