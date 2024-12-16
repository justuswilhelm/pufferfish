{ config, pkgs, ... }:
let
  logPath = "/var/log/atticd";
  attic-client = pkgs.attic-client;
  attic-server = pkgs.attic-server;
  cache-url = "https://lithium.local:10100/lithium-default";
  statePath = "/var/lib/attic";
in
{
  users.groups.attic = {
    gid = 603;
  };
  users.users.attic = {
    home = statePath;
    createHome = false;
    description = "attic user";
    gid = 603;
    uid = 53;
    isHidden = true;
  };
  users.knownGroups = [
    "attic"
  ];
  users.knownUsers = [
    "attic"
  ];

  environment.systemPackages = [
    attic-client
    attic-server
  ];
  environment.etc = {
    atticd = {
      source = ./atticd.toml;
      target = "attic/atticd.toml";
    };
  };

  launchd.daemons.attic = {
    script = ''
      ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="$(cat ${statePath}/secrets/secret.base64)"
      export ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64
      exec ${attic-server}/bin/atticd --config /etc/attic/atticd.toml
    '';
    serviceConfig = {
      KeepAlive = true;
      StandardOutPath = "${logPath}/attic.stdout.log";
      StandardErrorPath = "${logPath}/attic.stderr.log";
      UserName = "attic";
    };
  };

  # Derived from running attic use lithium-default
  nix.settings.substituters = [ cache-url ];
  nix.settings.trusted-public-keys = [
    "lithium-default:12m8tx3dPRBH0y4Gf6t/4eGh7Y8AJ7r2TT0Ug/w9Wvo="
  ];
  nix.settings.trusted-substituters = [ cache-url ];
  nix.settings.netrc-file = "/etc/nix/netrc";

  # TODO create startup script that
  # 1. creates run time folders, and assigns them to attic/attic, and chmods
  #    g,o=
  # 2. creates secret - if it doesn't exist

  system.activationScripts.preActivation = {
    text = ''
      mkdir -p ${logPath} ${statePath}
      mkdir -p ${statePath}/secrets
      chown -R attic:attic ${logPath} ${statePath}
      chmod -R go= ${statePath}
      if [ ! -e ${statePath}/secrets/secret.base64 ]; then
        echo "This is where a new secret gets generated"
        # head -c32 /dev/urandom | base64 | sudo tee /var/lib/attic/secrets/secret.base64
      fi
    '';
  };
}
