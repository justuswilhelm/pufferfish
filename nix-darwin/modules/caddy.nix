# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.caddy;

  logPath = "/var/log/caddy";
  statePath = "/var/lib/caddy";
  caStatePath = "/var/lib/lithium-ca";

  caddy = pkgs.caddy;
  caddyConfig = pkgs.writeText "Caddyfile" (
    ''
      {
        log {
          format console
        }
        # Prevent Caddy from serving on port :80 and disable certificate
        # automation.
        # https://caddyserver.com/docs/caddyfile/options#auto-https
        auto_https off
      }

      (certs) {
        tls ${statePath}/certs/lithium-server.crt ${statePath}/secrets/lithium-server.key
      }

    ''
    + cfg.extraConfig
  );
  caddyConfigValidated = pkgs.runCommand "Caddyfile" { preferLocalBuild = true; } ''
    ${caddy}/bin/caddy fmt - < ${caddyConfig} > Caddyfile
    # Broken
    # ${caddy}/bin/caddy validate --config Caddyfile
    mv Caddyfile $out
  '';

  # https://wiki.nixos.org/wiki/PHP#Apache,_plugins,_settings
  php = pkgs.php.buildEnv { };

  # TODO check if still needed Justus 2025-11-11
  # https://github.com/NixOS/nixpkgs/blob/54830391487253422f0ccab55fc557b2e725ace0/nixos/modules/services/web-servers/apache-httpd/default.nix#L319
  phpIni =
    pkgs.runCommand "php.ini"
      {
        preferLocalBuild = true;
      }
      ''
        cat ${php}/etc/php.ini > $out
        cat ${php.phpIni} > $out
      '';

  phpFpmCfg =
    let
      stderr = "/dev/stderr";
    in
    lib.generators.toINIWithGlobalSection { } {
      globalSection = {
        error_log = stderr;
        daemonize = "no";
      };
      sections = {
        php = {
          listen = cfg.phpFpmSock;
          "php_admin_value[disable_functions]" = "exec,passthru,shell_exec,system";
          "php_admin_flag[allow_url_fopen]" = "off";
          # Choose how the process manager will control the number of child processes.
          pm = "static";
          "pm.max_children" = 1;
          slowlog = stderr;
          "access.log" = stderr;
        };
      };
    };
in
{
  options = {
    services.caddy.extraConfig = mkOption {
      type = types.lines;
      default = "";
    };
    services.caddy.enablePhp = mkOption {
      type = types.bool;
      default = false;
      description = "Enable php-fpm";
    };
    services.caddy.phpFpmSock = mkOption {
      type = types.uniq types.str;
      default = "${statePath}/php.sock";
      description = "Socket path for php-fpm";
    };
    services.caddy.logPath = mkOption {
      type = types.uniq types.str;
      default = logPath;
      description = "Path where caddy log files go";
    };
  };
  config = {
    users.groups.lithium-ca = {
      gid = 1101;
    };
    users.users.lithium-ca = {
      description = "Lithium CA";
      home = caStatePath;
      gid = 1101;
      uid = 1101;
      isHidden = true;
    };

    users.groups.caddy = {
      gid = 602;
    };
    users.users.caddy = {
      home = statePath;
      description = "Caddy";
      gid = 602;
      uid = 52;
      isHidden = true;
    };

    users.knownGroups = [
      "lithium-ca"
      "caddy"
    ];
    users.knownUsers = [
      "lithium-ca"
      "caddy"
    ];

    environment.etc."caddy/Caddyfile".source = caddyConfigValidated;

    environment.etc."caddy/php.ini".source = phpIni;
    environment.etc."caddy/php.ini".enable = cfg.enablePhp;
    environment.etc."caddy/php-fpm.cfg".text = phpFpmCfg;
    environment.etc."caddy/php-fpm.cfg".enable = cfg.enablePhp;

    services.newsyslog.modules.caddy = {
      "${logPath}/caddy.log" = {
        owner = "caddy";
        group = "caddy";
        mode = "640";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
      "${logPath}/phpfpm.log" = {
        owner = "caddy";
        group = "caddy";
        mode = "640";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
    };

    services.nagios.objectDefs =
      let
        host = "localhost";
        port = 2019;
        nagiosCfg = pkgs.writeText "caddy.cfg" ''
          define service {
              use generic-service
              host_name ${host}
              service_description Caddy
              display_name Caddy web server
              check_command check_curl!-p ${toString port} --expect='HTTP/1.1 404'
          }
        '';
      in
      lib.optional config.services.nagios.enable nagiosCfg;

    environment.systemPackages = [ caddy ] ++ (lib.lists.optional cfg.enablePhp php);

    launchd.daemons.caddy = {
      script = ''
        if [ ! -e ${statePath}/secrets/jwt_shared_key ] ; then
          openssl rand -hex 16 | tr -d '\n' > ${statePath}/secrets/jwt_shared_key
        fi
        JWT_SHARED_KEY=$(cat ${statePath}/secrets/jwt_shared_key)
        export JWT_SHARED_KEY
        exec ${caddy}/bin/caddy run --config /etc/caddy/Caddyfile
      '';
      serviceConfig = {
        KeepAlive = true;
        StandardErrorPath = "${logPath}/caddy.log";
        UserName = "caddy";
        GroupName = "caddy";
      };
    };
    launchd.daemons.phpfpm = mkIf cfg.enablePhp {
      path = [ php ];
      serviceConfig = {
        UserName = "caddy";
        GroupName = "caddy";
        KeepAlive = true;
        StandardErrorPath = "${logPath}/phpfpm.log";
        WorkingDirectory = statePath;
      };
      command = "php-fpm -y /etc/caddy/php-fpm.cfg -c /etc/caddy/php.ini";
    };

    # This is a bit flaky, sometimes this cert is not included in
    # /etc/ssl/certs/ca-ceriticates.crt
    security.pki.certificateFiles = [ ../../nix/lithium-ca.crt ];

    system.activationScripts.preActivation = {
      text = ''
        mkdir -p ${logPath} ${statePath} ${statePath}/secrets
        chown caddy:caddy ${logPath} ${statePath} ${statePath}/secrets
        chmod go= ${statePath}/secrets

        mkdir -p ${caStatePath} ${caStatePath}/signed ${caStatePath}/secrets
        chmod go= ${caStatePath}/secrets
        chown lithium-ca:lithium-ca ${caStatePath} ${caStatePath}/signed
      '';
    };

    # Restart caddy
    system.activationScripts.postActivation = {
      text = ''
        echo "Restarting caddy"
        launchctl kickstart -k system/${config.launchd.labelPrefix}.caddy
      '';
    };
  };
}
