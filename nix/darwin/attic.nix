{ config, pkgs, ... }:
let
  logPath = "/var/log/atticd";
  attic-client = pkgs.attic-client;
  attic-server = pkgs.attic-server;
in
{
  users.groups.attic = {
    gid = 603;
  };
  users.users.attic = {
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
  ];
  environment.etc = {
    atticd = {
      source = ./atticd.toml;
      target = "attic/atticd.toml";
    };
  };

  launchd.daemons.attic = {
    script = ''
      ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="$(cat /etc/attic/secret.base64)"
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
  nix.settings.substituters = [
    "https://lithium.local:10100/lithium-default"
  ];
  nix.settings.trusted-public-keys = [
    "lithium-default:12m8tx3dPRBH0y4Gf6t/4eGh7Y8AJ7r2TT0Ug/w9Wvo="
  ];
  nix.settings.trusted-substituters = [
    "https://lithium.local:10100/lithium-default"
  ];
  nix.settings.netrc-file = "/etc/nix/netrc";
}
