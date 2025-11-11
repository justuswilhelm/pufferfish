# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# TODO make this a nix module
{ config, lib, pkgs, ... }:
let
  radicaleState = "/var/lib/radicale";
  logPath = "/var/log/radicale/radicale.log";

  radicale = pkgs.radicale;
  host = "localhost";
  caddyPort = 10102;
  # TODO check if this value can't be refactored somehow
  caddyHost = "lithium.local";
  port = 18110;
  radicaleConfig = pkgs.writeText "config" (lib.generators.toINI { } {
    server = {
      hosts = "127.0.0.1:${toString port}";
    };

    auth = {
      type = "htpasswd";
      htpasswd_filename = "${radicaleState}/users";
      htpasswd_encryption = "bcrypt";
    };

    storage = {
      filesystem_folder = "${radicaleState}/collections";
    };
  });

  caddyConfig = ''
    # Radicale
    https://${caddyHost}:${toString caddyPort} {
      import certs

      reverse_proxy ${host}:${toString port}

      log {
        format console
        output file ${config.services.caddy.logPath}/radicale.log
      }
    }
  '';
in
{

  services.nagios.objectDefs =
    let
      healthEndpoint = "/.web/";
      cfg = pkgs.writeText "radicale.cfg" ''
        define service {
            use generic-service
            host_name ${caddyHost}
            service_description radicale
            display_name Radicale DAV
            # No health endpoint there
            check_command check_curl!-p ${toString caddyPort} --ssl=1.3 --url=${healthEndpoint}
        }

        define service {
            use generic-service
            host_name ${host}
            service_description radicale
            display_name Radicale DAV (${host})
            # No health endpoint there
            check_command check_curl!-p ${toString port} --url=${healthEndpoint} --expect='HTTP/1.0 200 OK'
        }
      '';
    in
    lib.optional config.services.nagios.enable cfg;
  users.groups.radicale = { gid = 1020; };
  users.users.radicale = {
    description = "Radicale User";
    gid = 1020;
    uid = 1020;
    isHidden = true;
  };
  users.knownGroups = [ "radicale" ];
  users.knownUsers = [ "radicale" ];

  environment.etc."radicale/config".source = radicaleConfig;

  services.newsyslog.modules.radicale = {
    ${logPath} = {
      owner = "radicale";
      group = "radicale";
      mode = "640";
      count = 10;
      size = "*";
      when = "$D0";
      flags = "J";
    };
  };

  services.caddy.extraConfig = caddyConfig;

  environment.systemPackages = [ radicale ];
  launchd.daemons.radicale = {
    command = "${radicale}/bin/radicale";
    serviceConfig = {
      KeepAlive = true;
      # Radicale only logs to stderr
      StandardErrorPath = logPath;
      UserName = "radicale";
      GroupName = "radicale";
    };
  };
  system.activationScripts.postActivation = {
    text = ''
      echo "Ensuring radicale directories exist"
      sudo mkdir -p ${radicaleState} "$(dirname ${logPath})"
      sudo chown radicale:radicale ${radicaleState} "$(dirname ${logPath})"
      sudo chmod go= ${radicaleState}
      echo "Restarting radicale"
      launchctl kickstart -k system/${config.launchd.labelPrefix}.radicale
    '';
  };
}

