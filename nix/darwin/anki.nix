{ pkgs, ... }:
let
  anki = pkgs.anki-sync-server;
  logPath = "/var/log/anki";
  script = pkgs.writeShellApplication {
    name = "run-anki-sync-server";
    runtimeInputs = [ anki ];
    text = ''
      export SYNC_HOST=127.0.0.1
      export SYNC_PORT=18090
      export SYNC_BASE=/var/anki
      SYNC_USER1="$(cat /etc/anki/sync_user1)"
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
  };
in
{
  launchd.daemons.anki = {
    serviceConfig = {
      KeepAlive = true;
      Program = "${script}/bin/run-anki-sync-server";
      StandardOutPath = "${logPath}/anki-sync-server.stdout.log";
      StandardErrorPath = "${logPath}/anki-sync-server.stderr.log";
    };
  };
}
