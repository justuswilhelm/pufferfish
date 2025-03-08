{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.caddy;

  logPath = "/var/log/caddy";
  statePath = "/var/lib/caddy";
  caStatePath = "/var/lib/lithium-ca";

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

  phpFpmSock = "${statePath}/php.sock";


  caddy = pkgs.caddy.withPlugins {
    plugins = [
      # caddy-cgi v2.2.6 relies on go 1.24.0
      # caddy-cgi v2.2.5 works with go 1.23.6
      "github.com/aksdb/caddy-cgi/v2@v2.2.5"
      "github.com/greenpau/caddy-security@v1.1.29"
    ];
    hash = "sha256-Bzqu6GDMNgYV4F1TJGCYEmjDaD6vlm7LpoH4MuJLL8U=";
  };
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
          path {$HOME}/.local/caddy/users.json
        }

        authentication portal myportal {
          enable identity store localdb
        }
        authorization policy admins_policy {
          set auth url https://lithium.local:10103/auth

          allow roles authp/admin

          set user identity subject

          enable strip token
          inject header "REMOTE_USER" from subject

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
      tls /var/lib/caddy/certs/lithium-server.crt /var/lib/caddy/secrets/lithium-server.key
    }

    # Attic
    https://lithium.local:10100 {
      import certs

      reverse_proxy localhost:18080

      log {
        format console
        output file /var/log/caddy/attic.log
      }
    }

    # Anki
    https://lithium.local:10101 {
      import certs

      reverse_proxy localhost:18090

      log {
        format console
        output file /var/log/caddy/anki.log
      }
    }

    # Radicale
    https://lithium.local:10102 {
      import certs

      reverse_proxy localhost:18110

      log {
        format console
        output file /var/log/caddy/radicale.log
      }
    }

    # ntfy-sh
    https://lithium.local:10104 {
      import certs

      reverse_proxy localhost:18130

      log {
        format console
        output file /var/log/caddy/ntfy-sh.log
      }
    }
  '' + cfg.extraConfig);
  caddyConfigValidated = pkgs.runCommand "Caddyfile" { preferLocalBuild = true; } ''
    ${caddy}/bin/caddy fmt - < ${caddyConfig} > Caddyfile
    # Broken
    # ${caddy}/bin/caddy validate --config Caddyfile
    mv Caddyfile $out
  '';
in
{
  options = {
    services.caddy.extraConfig = mkOption {
      type = types.str;
      default = "";
    };
    services.caddy.enablePhp = mkOption {
      type = types.bool;
      default = false;
      description = "Enable php-fpm";
    };
    services.caddy.phpFpmSock = mkOption {
      type = types.uniq types.str;
      default = phpFpmSock;
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
    environment.etc."caddy/php-fpm.cfg".text = ''
      error_log = ${logPath}/phpfpm.error.log
      [php]
      listen = ${phpFpmSock}
      php_admin_value[disable_functions] = exec,passthru,shell_exec,system
      php_admin_flag[allow_url_fopen] = off
      ; Choose how the process manager will control the number of child processes.
      pm = static
      pm.max_children = 1
      slowlog = ${logPath}/phpfpm.slowlog.log
    '';
    environment.etc."caddy/php-fpm.cfg".enable = cfg.enablePhp;

    # Copied from /etc/newsyslog.d/wifi.conf
    environment.etc."newsyslog.d/caddy.conf".text = ''
      # logfilename               [owner:group] mode count size when  flags [/pid_file] [sig_num]
      ${logPath}/caddy.stderr.log caddy:caddy   640  10    *    $D0   J
    '';

    environment.systemPackages = [ caddy ];

    launchd.daemons.caddy = {
      command = "${caddy}/bin/caddy run --config /etc/caddy/Caddyfile";
      serviceConfig = {
        KeepAlive = true;
        StandardErrorPath = "${logPath}/caddy.stderr.log";
        UserName = "caddy";
        GroupName = "caddy";
      };
    };
    launchd.daemons.phpfpm = {
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
    security.pki.certificateFiles = [ ../nix/lithium-ca.crt ];

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
        caddy validate --config /etc/caddy/Caddyfile

        echo "Restarting caddy"
        launchctl kickstart -k system/${config.launchd.labelPrefix}.caddy
      '';
    };
  };
}
