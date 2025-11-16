# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib, pkgs, config, ... }:
let
  username = "wiki";
  groupname = "wiki";
  home = "/var/lib/wiki";
  logPath = "/var/log/${username}";
  host = "localhost";
  port = 18200;
  caddyHost = "lithium.local";
  caddyPort = 10106;

  caddyConfig = ''
    # MediaWiki
    https://${caddyHost}:${toString caddyPort} {
      import certs

      root * ${home}/mediawiki
      php_fastcgi unix//${config.services.caddy.phpFpmSock}
      file_server

      log {
        format console
        output file ${config.services.caddy.logPath}/wiki.log
      }
    }
  '';
in
{
  users.groups.wiki = {
    gid = 1102;
  };
  users.users.wiki = {
    inherit home;
    description = "MediaWiki user";
    gid = 1102;
    uid = 1102;
    isHidden = true;
  };
  users.knownGroups = [ "wiki" ];
  users.knownUsers = [ "wiki" ];

  services.nagios.objectDefs =
    let
      healthEndpoint = "/index.php?title=Main_Page";
      wikiNagios = pkgs.writeText "wiki.cfg" ''
        define service {
            use generic-service
            host_name ${caddyHost}
            service_description mediawiki
            display_name MediaWiki (Caddy)
            check_command check_curl!-p ${toString caddyPort} --ssl=1.3 --expect='HTTP/2 200' --url=${healthEndpoint}
        }
      '';
    in
    lib.optional config.services.nagios.enable wikiNagios;

  services.caddy = {
    extraConfig = caddyConfig;
    enablePhp = true;
  };

  system.activationScripts.postActivation = {
    text = ''
      mkdir -p ${logPath} ${home}
      chown caddy:caddy ${logPath} ${home}
      chmod 750 ${home}
      chmod 750 ${logPath}
    '';
  };
}
