
{ config, pkgs, ... }:
{
  environment.systemPackages = [
    # Nix caching
    pkgs.attic-client
  ];
  environment.etc = {
    atticd = {
      source = ./atticd.toml;
      target = "attic/atticd.toml";
    };
  };

  launchd.daemons.attic = {
    serviceConfig =
      let
        logPath = "/var/log/atticd";
        script = pkgs.writeShellApplication {
          name = "run-atticd";
          runtimeInputs = with pkgs; [ attic-server ];
          text = ''
            ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="$(cat /etc/attic/secret.base64)"
            export ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64
            exec atticd --config /etc/attic/atticd.toml
          '';
        };
      in
      {
        KeepAlive = true;
        Program = "${script}/bin/run-atticd";
        StandardOutPath = "${logPath}/attic.stdout.log";
        StandardErrorPath = "${logPath}/attic.stderr.log";
      };
  };

  # Derived from running attic use lithium-default
  nix.settings.substituters = [
    "https://lithium.local:10800/lithium-default"
  ];
  nix.settings.trusted-public-keys = [
    "lithium-default:12m8tx3dPRBH0y4Gf6t/4eGh7Y8AJ7r2TT0Ug/w9Wvo="
  ];
  nix.settings.trusted-substituters = [
    "https://lithium.local:10800/lithium-default"
  ];
  nix.settings.netrc-file = "/etc/nix/netrc";
}
