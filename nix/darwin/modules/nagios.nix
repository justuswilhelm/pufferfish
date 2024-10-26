# Copyright (c) 2003-2024 Eelco Dolstra and the Nixpkgs/NixOS contributors
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# Nagios system/network monitoring daemon.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nagios;

  nagiosState = "/var/nagios";
  nagiosLogDir = "/var/log/nagios";
  nagiosHttpdState = "/var/nagios-httpd";
  nagiosHttpdLogDir = "/var/log/nagios-httpd";
  urlPath = "/nagios";

  nagiosObjectDefs = cfg.objectDefs;

  nagiosObjectDefsDir = pkgs.runCommand "nagios-objects"
    {
      inherit nagiosObjectDefs;
      preferLocalBuild = true;
    } "mkdir -p $out; ln -s $nagiosObjectDefs $out/";

  nagiosCfgFile =
    let
      default = {
        log_file = "${nagiosLogDir}/current";
        log_archive_path = "${nagiosLogDir}/archive";
        status_file = "${nagiosState}/status.dat";
        object_cache_file = "${nagiosState}/objects.cache";
        temp_file = "${nagiosState}/nagios.tmp";
        lock_file = "/run/nagios.lock";
        state_retention_file = "${nagiosState}/retention.dat";
        query_socket = "${nagiosState}/nagios.qh";
        check_result_path = "${nagiosState}";
        command_file = "${nagiosState}/nagios.cmd";
        cfg_dir = "${nagiosObjectDefsDir}";
        nagios_user = "nagios";
        nagios_group = "nagios";
        illegal_macro_output_chars = "`~$&|'\"<>";
        retain_state_information = "1";
        # Stop Nagios from phoning home
        #  ⠀⠀.-------------------------------------------.
        #    |⠀ Nagios monitors the world and we         |
        #  ⠀⠀|⠀monitor Nagios taking over the world. :-) |
        #  ⠀⠀.-------------------------------------------.
        #⠀⠀⠀⠀
        # ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
        # ░░░░░░░░░░░░░▄▄▄▄▄▄▄░░░░░░░░░
        # ░░░░░░░░░▄▀▀▀░░░░░░░▀▄░░░░░░░
        # ░░░░░░░▄▀░░░░░░░░░░░░▀▄░░░░░░
        # ░░░░░░▄▀░░░░░░░░░░▄▀▀▄▀▄░░░░░
        # ░░░░▄▀░░░░░░░░░░▄▀░░██▄▀▄░░░░
        # ░░░▄▀░░▄▀▀▀▄░░░░█░░░▀▀░█▀▄░░░
        # ░░░█░░█▄▄░░░█░░░▀▄░░░░░▐░█░░░
        # ░░▐▌░░█▀▀░░▄▀░░░░░▀▄▄▄▄▀░░█░░
        # ░░▐▌░░█░░░▄▀░░░░░░░░░░░░░░█░░
        # ░░▐▌░░░▀▀▀░░░░░░░░░░░░░░░░▐▌░
        # ░░▐▌░░░░░░░░░░░░░░░▄░░░░░░▐▌░
        # ░░▐▌░░░░░░░░░▄░░░░░█░░░░░░▐▌░
        # ░░░█░░░░░░░░░▀█▄░░▄█░░░░░░▐▌░
        # ░░░▐▌░░░░░░░░░░▀▀▀▀░░░░░░░▐▌░
        # ░░░░█░░░░░░░░░░░░░░░░░░░░░█░░
        # ░░░░▐▌▀▄░░░░░░░░░░░░░░░░░▐▌░░
        # ░░░░░█░░▀░░░░░░░░░░░░░░░░▀░░░
        # ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
        #⠀⠀⠀⠀
        check_for_updates = "0";
      };
      lines = mapAttrsToList (key: value: "${key}=${value}") (default // cfg.extraConfig);
      content = concatStringsSep "\n" lines;
      file = pkgs.writeText "nagios.cfg" content;
      validated = pkgs.runCommand "nagios-checked.cfg" { preferLocalBuild = true; } ''
        cp ${file} nagios.cfg
        # nagios checks the existence of /var/lib/nagios, but
        # it does not exist in the build sandbox, so we fake it
        mkdir lib
        lib=$(readlink -f lib)
        sed -i s@=${nagiosState}@=$lib@ nagios.cfg
        ${pkgs.nagios}/bin/nagios -v nagios.cfg && cp ${file} $out
      '';
      defaultCfgFile = if cfg.validateConfig then validated else file;
    in
    if cfg.mainConfigFile == null then defaultCfgFile else cfg.mainConfigFile;

  # Plain configuration for the Nagios web-interface with http basic auth
  # https://docs.redhat.com/en/documentation/red_hat_gluster_storage/3/html/administration_guide/sect-nagios_advanced_configuration
  nagiosCGICfgFile = pkgs.writeText "nagios.cgi.conf"
    ''
      main_config_file=${nagiosCfgFile}
      use_authentication=1
      url_html_path=${urlPath}
      authorized_for_system_information=nagiosadmin
      authorized_for_configuration_information=nagiosadmin
      authorized_for_system_commands=nagiosadmin
      authorized_for_all_services=nagiosadmin
      authorized_for_all_hosts=nagiosadmin
      authorized_for_all_service_commands=nagiosadmin
      authorized_for_all_host_commands=nagiosadmin
    '';

  httpd = pkgs.apacheHttpd;
  php = ((pkgs.php.overrideAttrs
    (previous: {
      buildInputs = previous.buildInputs ++ [ pkgs.openldap ];
    })).override {
    apacheHttpd = httpd;
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

  httpdConfig = pkgs.writeText "httpd.conf" ''
    LoadModule env_module ${httpd}/modules/mod_env.so
    LoadModule alias_module ${httpd}/modules/mod_alias.so
    LoadModule cgi_module ${httpd}/modules/mod_cgi.so
    LoadModule dir_module ${httpd}/modules/mod_dir.so
    # This is so that apache can fork?
    LoadModule mpm_prefork_module ${httpd}/modules/mod_mpm_prefork.so
    LoadModule log_config_module ${httpd}/modules/mod_log_config.so
    # Authentication
    LoadModule authn_core_module ${httpd}/modules/mod_authn_core.so
    LoadModule auth_basic_module ${httpd}/modules/mod_auth_basic.so
    LoadModule authn_file_module ${httpd}/modules/mod_authn_file.so
    # 'Require' directive
    LoadModule authz_core_module ${httpd}/modules/mod_authz_core.so
    LoadModule authz_user_module ${httpd}/modules/mod_authz_user.so
    # Something for file access
    LoadModule unixd_module ${httpd}/modules/mod_unixd.so
    # Scary PHP
    LoadModule mime_module ${httpd}/modules/mod_mime.so
    LoadModule php_module ${php}/modules/libphp.so

    AddType application/x-httpd-php .php

    PidFile ${nagiosHttpdState}/httpd.pid

    ServerName localhost
    Listen 18120

    # Logging
    ErrorLog "${nagiosHttpdLogDir}/httpd.error.log"
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    CustomLog "${nagiosHttpdLogDir}/httpd.access.log" common

    ScriptAlias ${urlPath}/cgi-bin ${pkgs.nagios}/sbin

    # This http basic auth config will definitely get me hacked
    <Directory "${pkgs.nagios}/sbin">
      Options ExecCGI
      SetEnv NAGIOS_CGI_CONFIG ${cfg.cgiConfigFile}
      AllowOverride None
      AuthType Basic
      AuthName "Nagios Access"
      AuthBasicProvider file
      AuthUserFile ${nagiosHttpdState}/htpasswd.users
      Require valid-user
    </Directory>

    Alias ${urlPath} ${pkgs.nagios}/share

    <Directory "${pkgs.nagios}/share">
      Options None
      Require all granted
      DirectoryIndex index.php
    </Directory>
  '';
  overlays = [
    (final: previous: {
      monitoring-plugins = (previous.monitoring-plugins.overrideAttrs (
        final: previous: rec {
          version = "2.4.0";
          src = pkgs.fetchFromGitHub {
            owner = "monitoring-plugins";
            repo = "monitoring-plugins";
            rev = "v${version}";
            sha256 = "sha256-J9fzlxIpujoG7diSRscFhmEV9HpBOxFTJSmGGFjAzcM=";
          };
          patches = [ ./monitoring-plugins.patch ];
          meta.platforms = pkgs.lib.platforms.all;
        }
      )).override {
        lm_sensors = null;
        net-snmp = null;
      };
    })
  ];
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "nagios" "urlPath" ] "The urlPath option has been removed as it is hard coded to /nagios in the nagios package.")
  ];

  meta.maintainers = with lib.maintainers; [ symphorien ];

  options = {
    services.nagios = {
      enable = mkEnableOption ''[Nagios](https://www.nagios.org/) to monitor your system or network'';

      objectDefs = mkOption {
        description = ''
          A list of Nagios object configuration files that must define
          the hosts, host groups, services and contacts for the
          network that you want Nagios to monitor.
        '';
        type = types.listOf types.path;
        example = literalExpression "[ ./objects.cfg ]";
      };

      plugins = mkOption {
        type = types.listOf types.package;

        default = with pkgs; [ monitoring-plugins msmtp mailutils ];
        defaultText = literalExpression "[pkgs.monitoring-plugins pkgs.msmtp pkgs.mailutils]";
        description = ''
          Packages to be added to the Nagios {env}`PATH`.
          Typically used to add plugins, but can be anything.
        '';
      };

      mainConfigFile = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = ''
          If non-null, overrides the main configuration file of Nagios.
        '';
      };

      extraConfig = mkOption {
        type = types.attrsOf types.str;
        example = {
          debug_level = "-1";
          debug_file = "/var/log/nagios/debug.log";
        };
        default = { };
        description = "Configuration to add to /etc/nagios.cfg";
      };

      validateConfig = mkOption {
        type = types.bool;
        default = pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform;
        defaultText = literalExpression "pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform";
        description = "if true, the syntax of the nagios configuration file is checked at build time";
      };

      cgiConfigFile = mkOption {
        type = types.package;
        default = nagiosCGICfgFile;
        defaultText = literalExpression "nagiosCGICfgFile";
        description = ''
          Derivation for the configuration file of Nagios CGI scripts
          that can be used in web servers for running the Nagios web interface.
        '';
      };

      enableWebInterface = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Nagios web interface.  You should also
          enable Apache ({option}`services.httpd.enable`).
        '';
      };

      virtualHost = mkOption {
        type = types.submodule (import ../web-servers/apache-httpd/vhost-options.nix);
        example = literalExpression ''
          { hostName = "example.org";
            adminAddr = "webmaster@example.org";
            enableSSL = true;
            sslServerCert = "/var/lib/acme/example.org/full.pem";
            sslServerKey = "/var/lib/acme/example.org/key.pem";
          }
        '';
        description = ''
          Apache configuration can be done by adapting {option}`services.httpd.virtualHosts`.
          See [](#opt-services.httpd.virtualHosts) for further information.
        '';
      };
    };
  };


  config = mkIf cfg.enable {
    nixpkgs.overlays = overlays;
    users.users.nagios = {
      description = "Nagios user";
      uid = 1100;
      home = nagiosState;
      gid = 1100;
      isHidden = true;
    };
    # TODO make disable-able
    users.users.nagios-httpd = {
      description = "Nagios Httpd user";
      uid = 1105;
      home = nagiosHttpdState;
      gid = 1105;
      isHidden = true;
    };
    users.knownUsers = [ "nagios" "nagios-httpd"];

    users.groups.nagios = {
      gid = 1100;
    };
    users.groups.nagios-httpd = {
      gid = 1105;
    };
    users.groups.nagios-cmd = {
      gid = 1106;
      members = [ "nagios" "nagios-httpd" ];
    };
    # Allow cgi file to write to nagios.cmd file
    # https://web.archive.org/web/20220327165441/http://nagios.manubulon.com/traduction/docs14en/commandfile.html
    users.knownGroups = [ "nagios" "nagios-httpd" "nagios-cmd" ];

    # This isn't needed, it's just so that the user can type "nagiostats
    # -c /etc/nagios.cfg".
    environment.etc."nagios/nagios.cfg".source = nagiosCfgFile;
    # TODO make these two optional
    environment.etc."nagios/httpd.conf".source = httpdConfig;
    environment.etc."nagios/httpd.conf".enable = cfg.enableWebInterface;
    environment.etc."nagios/php.ini".source = phpIni;
    environment.etc."nagios/php.ini".enable = cfg.enableWebInterface;

    environment.systemPackages = [ pkgs.nagios pkgs.monitoring-plugins ];
    launchd.daemons.nagios = {
      path = [ pkgs.nagios ] ++ cfg.plugins;

      serviceConfig = {
        UserName = "nagios";
        GroupName = "nagios";
        KeepAlive = true;
        StandardOutPath = "${nagiosLogDir}/stdout.log";
        StandardErrorPath = "${nagiosLogDir}/stderr.log";
        WorkingDirectory = nagiosState;
        # Thx https://github.com/JasonRivers/Docker-Nagios/issues/135
        SoftResourceLimits = {
          NumberOfFiles = 32768;
        };
        HardResourceLimits = {
          NumberOfFiles = 32768;
        };
      };
      command = "${pkgs.nagios}/bin/nagios /etc/nagios/nagios.cfg";
    };

    environment.launchDaemons.nagios-httpd.enable = cfg.enableWebInterface;
    launchd.daemons.nagios-httpd = {
      path = [ httpd ];
      serviceConfig = {
        UserName = "nagios-httpd";
        GroupName = "nagios-httpd";
        KeepAlive = true;
        EnvironmentVariables = {
          PHPRC = "/etc/nagios/php.ini";
        };
        StandardOutPath = "${nagiosHttpdLogDir}/httpd.stdout.log";
        StandardErrorPath = "${nagiosHttpdLogDir}/httpd.stderr.log";
        WorkingDirectory = nagiosHttpdState;
      };
      command = "${httpd}/bin/httpd -D FOREGROUND -f /etc/nagios/httpd.conf";
    };

    # TODO make this optional
    # Create nagiosadmin user with
    # sudo -u nagios-httpd htpasswd -B /var/nagios-httpd/htpasswd.users nagiosadmin
    system.activationScripts.postActivation = {
      text = ''
        echo "Ensuring nagios directories exist"
        mkdir -vp ${nagiosLogDir}
        mkdir -vp ${nagiosState}
        chown -v nagios:nagios ${nagiosLogDir}
        echo "Ensuring nagios-cmd group can access ${nagiosState}"
        chown -v nagios:nagios-cmd ${nagiosState}
        chmod -v ug+rwx,g+s,o= ${nagiosState}

        echo "Restarting nagios"
        launchctl kickstart -k system/${config.launchd.labelPrefix}.nagios

        echo "Ensuring nagios httpd directories exist"
        mkdir -vp ${nagiosHttpdState}
        mkdir -vp ${nagiosHttpdLogDir}
        chmod -v 700 ${nagiosHttpdState}
        chown -v nagios-httpd:nagios-httpd ${nagiosHttpdState} ${nagiosHttpdLogDir}
        sudo -u nagios-httpd touch ${nagiosHttpdState}/htpasswd.users
        chmod -v 600 ${nagiosHttpdState}/htpasswd.users
        echo "Restarting nagios-httpd"
        launchctl kickstart -k system/${config.launchd.labelPrefix}.nagios-httpd
      '';
    };
  };
}
