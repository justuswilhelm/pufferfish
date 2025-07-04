{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.caddy;

  logPath = "/var/log/caddy";
  statePath = "/var/lib/caddy";
  caStatePath = "/var/lib/lithium-ca";

  caddy = pkgs.caddy.withPlugins {
    plugins = [
      # caddy-cgi v2.2.6 relies on go 1.24.0
      # caddy-cgi v2.2.5 works with go 1.23.6
      "github.com/aksdb/caddy-cgi/v2@v2.2.5"
      "github.com/greenpau/caddy-security@v1.1.29"
    ];
    hash = "sha256-0Bc7oWqdP2VMl64omfNn5oTGRQ6eRiN+8aTvlxRO/Bs=";
  };
  caddyCookieLifetime = 60 * 60 * 24 * 3;
  caddyConfig = pkgs.writeText "Caddyfile" (''
    {
      log {
        format console
      }
      # Prevent Caddy from serving on port :80 and disable certificate
      # automation.
      # https://caddyserver.com/docs/caddyfile/options#auto-https
      auto_https off

      # https://docs.authcrunch.com/docs/authenticate/local/local
      security {
        local identity store localdb {
          realm local
          path ${statePath}/secrets/users.json
        }

        authentication portal myportal {
          enable identity store localdb

          # The cookie should stay valid longer than the auth token
          # to redirect to the log in page if needed
          cookie lifetime ${toString (caddyCookieLifetime * 2)}

          crypto default token lifetime ${toString caddyCookieLifetime}
          crypto key sign-verify {env.JWT_SHARED_KEY}
        }
        authorization policy admins_policy {
          set auth url https://lithium.local:10103/auth

          crypto key verify {env.JWT_SHARED_KEY}

          allow roles authp/admin

          set user identity subject

          enable strip token

          acl rule {
            comment allow admins
            match role authp/admin
            allow stop log info
          }
          acl rule {
            comment default deny
            match any
            deny log warn
          }
        }
      }
    }

    (certs) {
      tls ${statePath}/certs/lithium-server.crt ${statePath}/secrets/lithium-server.key
    }

  '' + cfg.extraConfig);
  caddyConfigValidated = pkgs.runCommand "Caddyfile" { preferLocalBuild = true; } ''
    ${caddy}/bin/caddy fmt - < ${caddyConfig} > Caddyfile
    # Broken
    # ${caddy}/bin/caddy validate --config Caddyfile
    mv Caddyfile $out
  '';

  # TODO investigate whether these are still needed Justus 2025-05-30
  php = ((pkgs.php.overrideAttrs
    (previous: {
      buildInputs = previous.buildInputs ++ [ pkgs.openldap ];
    })).override {
    apxs2Support = true;
    # available extensions:
  }).withExtensions ({ all, ... }: with all; ([
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/development/interpreters/php/8.3.nix
    filter
  ]));

  # https://github.com/NixOS/nixpkgs/blob/54830391487253422f0ccab55fc557b2e725ace0/nixos/modules/services/web-servers/apache-httpd/default.nix#L319
  phpIni = pkgs.runCommand "php.ini"
    {
      preferLocalBuild = true;
    }
    ''
      cat ${php}/etc/php.ini > $out
      cat ${php.phpIni} > $out
    '';

  phpFpmCfg = lib.generators.toINIWithGlobalSection { } {
    globalSection = {
      error_log = "${logPath}/phpfpm.error.log";
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
        slowlog = "${logPath}/phpfpm.slowlog.log";
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
    users.groups.lithium-ca = { gid = 1101; };
    users.users.lithium-ca = {
      description = "Lithium CA";
      home = caStatePath;
      gid = 1101;
      uid = 1101;
      isHidden = true;
    };

    users.groups.caddy = { gid = 602; };
    users.users.caddy = {
      home = statePath;
      description = "Caddy";
      gid = 602;
      uid = 52;
      isHidden = true;
    };

    users.knownGroups = [ "lithium-ca" "caddy" ];
    users.knownUsers = [ "lithium-ca" "caddy" ];

    environment.etc."caddy/Caddyfile".source = caddyConfigValidated;

    environment.etc."caddy/php.ini".source = phpIni;
    environment.etc."caddy/php.ini".enable = cfg.enablePhp;
    environment.etc."caddy/php-fpm.cfg".text = phpFpmCfg;
    environment.etc."caddy/php-fpm.cfg".enable = cfg.enablePhp;

    services.newsyslog.modules.caddy = {
      "${logPath}/caddy.stderr.log" = {
        owner = "caddy";
        group = "caddy";
        mode = "640";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
      "${logPath}/phpfpm.stdout.log" = {
        owner = "caddy";
        group = "caddy";
        mode = "640";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
      "${logPath}/phpfpm.stderr.log" = {
        owner = "caddy";
        group = "caddy";
        mode = "640";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
      "${logPath}/phpfpm.error.log" = {
        owner = "caddy";
        group = "caddy";
        mode = "640";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
      "${logPath}/phpfpm.slowlog.log" = {
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

    environment.systemPackages = [ caddy ];

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
        StandardErrorPath = "${logPath}/caddy.stderr.log";
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
        StandardOutPath = "${logPath}/phpfpm.stdout.log";
        StandardErrorPath = "${logPath}/phpfpm.stderr.log";
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
        chown -R caddy:caddy ${logPath} ${statePath} ${statePath}/secrets
        chmod -R go= ${statePath}/secrets

        mkdir -p ${caStatePath} ${caStatePath}/signed ${caStatePath}/secrets
        chmod -R go= ${caStatePath}/secrets
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
