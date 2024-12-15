# TODO add password hashing
{ pkgs, ... }:
let
  anki-sync-server = pkgs.anki-sync-server;
  username = "anki-sync-server";
  groupname = "anki-sync-server";
  home = "/var/lib/${username}";
  statePath = "${home}/sync-base";
  usersPath = "${home}/users";
  syncUser1 = "${usersPath}/sync_user_1";
  logPath = "/var/log/${username}";
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

  launchd.daemons.anki-sync-server = {
    path = [ pkgs.coreutils anki-sync-server ];
    script = ''
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
      StandardOutPath = "${logPath}/anki-sync-server.stdout.log";
      StandardErrorPath = "${logPath}/anki-sync-server.stderr.log";
      UserName = username;
      EnvironmentVariables = {
        SYNC_HOST = "127.0.0.1";
        SYNC_PORT = "18090";
        SYNC_BASE = statePath;
      };
    };
  };
  system.activationScripts.preActivation = {
    text = ''
      mkdir -pv ${home} ${logPath} ${statePath} ${usersPath}

      chown -R ${username}:${groupname} ${home}
      chmod -R go= ${home}
    '';
  };
}
