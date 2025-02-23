# https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/misc/ntfy-sh.nix
{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.ntfy-sh;
  statePath = "/var/lib/ntfy-sh";
  logPath = "/var/log/ntfy-sh";

  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.ntfy-sh = {
    enable = mkEnableOption "[ntfy-sh](https://ntfy.sh), a push notification service";

    package = mkPackageOption pkgs "ntfy-sh" { };

    user = mkOption {
      default = "ntfy-sh";
      type = types.str;
      description = "User the ntfy-sh server runs under.";
    };

    group = mkOption {
      default = "ntfy-sh";
      type = types.str;
      description = "Primary group of ntfy-sh user.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = { };
      };

      default = { };

      example = literalExpression ''
        {
          listen-http = ":8080";
        }
      '';

      description = ''
        Configuration for ntfy.sh, supported values are [here](https://ntfy.sh/docs/config/#config-options).
      '';
    };
  };

  config =
    let
      configuration = settingsFormat.generate "server.yml" cfg.settings;
    in
    mkIf cfg.enable {
      # to configure access control via the cli
      environment = {
        etc."ntfy/server.yml".source = configuration;
        systemPackages = [ cfg.package ];
      };

      environment.etc."newsyslog.d/ntfy-sh.conf".text = ''
        # logfilename         [owner:group]            mode count size when  flags [/pid_file] [sig_num]
        ${logPath}/stdout.log ${cfg.user}:${cfg.group} 640  10    *    $D0   J
        ${logPath}/stderr.log ${cfg.user}:${cfg.group} 640  10    *    $D0   J
      '';

      services.ntfy-sh.settings = {
        auth-file = mkDefault "${statePath}/user.db";
        auth-default-access = "deny-all";
        behind-proxy = true;
        base-url = "https://lithium.local:10104";
        enable-login = true;
        listen-http = mkDefault "localhost:18130";
        attachment-cache-dir = mkDefault "${statePath}/attachments";
        cache-file = mkDefault "${statePath}/cache-file.db";
      };
      launchd.daemons.ntfy-sh = {
        command = "${cfg.package}/bin/ntfy serve -c /etc/ntfy/server.yml";
        serviceConfig = {
          UserName = cfg.user;
          KeepAlive = true;
          StandardOutPath = "${logPath}/stdout.log";
          StandardErrorPath = "${logPath}/stderr.log";
        };
      };

      users.knownGroups = optionalAttrs (cfg.group == "ntfy-sh") [ "ntfy-sh" ];
      users.knownUsers = optionalAttrs (cfg.user == "ntfy-sh") [ "ntfy-sh" ];
      users.groups = optionalAttrs (cfg.group == "ntfy-sh") {
        ntfy-sh = {
          gid = 605;
        };

      };
      users.users = optionalAttrs (cfg.user == "ntfy-sh") {
        ntfy-sh = {
          description = "ntfy-sh user";
          home = statePath;
          gid = 605;
          uid = 605;
          isHidden = true;
        };
      };
      system.activationScripts.postActivation = {
        text = ''
          mkdir -v -p ${statePath} ${logPath}
          chmod 700 ${statePath} ${logPath}
          chown -R ntfy-sh:ntfy-sh ${statePath} ${logPath}
          launchctl kickstart -k system/${config.launchd.labelPrefix}.ntfy-sh
        '';
      };
    };
}

