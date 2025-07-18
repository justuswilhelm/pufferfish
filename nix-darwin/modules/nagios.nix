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

  nagiosState = "/var/lib/nagios";
  nagiosRw = "/var/lib/nagios-rw";
  # TODO create separate directory for nagios-cmd things
  nagiosLogDir = "/var/log/nagios";
  nagiosNscaState = "/var/lib/nagios-nsca";
  nagiosNscaLogDir = "/var/log/nagios-nsca";
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
        lock_file = "${nagiosState}/nagios.lock";
        state_retention_file = "${nagiosState}/retention.dat";
        query_socket = "${nagiosState}/nagios.qh";
        check_result_path = "${nagiosState}";
        command_file = "${nagiosRw}/nagios.cmd";
        cfg_dir = "${nagiosObjectDefsDir}";
        nagios_user = "nagios";
        nagios_group = "nagios";
        illegal_macro_output_chars = "`~$&|'\"<>";
        retain_state_information = "1";
        accept_passive_service_checks = "1";
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
        resource_file = nagiosResourceFile;
      };
      content = lib.generators.toINIWithGlobalSection { } {
        globalSection = default // cfg.extraConfig;
      };
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
      main_config_file=/etc/nagios/nagios.cfg
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

  nagiosResourceFile = pkgs.writeText "resource.cfg" ''
    $USER1$=${pkgs.monitoring-plugins}/bin
  '';

  caddyConfig = ''
    https://lithium.local:10103 {
      import certs

      route /auth* {
        authenticate with myportal
      }

      route {
        authorize with admins_policy

        handle_path ${urlPath}/cgi-bin/* {
          # nagios looks for REMOTE_USER header
          # https://github.com/NagiosEnterprises/nagioscore/blob/2706fa7a451afe48bd4dc240d72d23fdcec0d9ef/cgi/cgiauth.c#L38
          # temp_ptr = getenv("REMOTE_USER");
          # https://github.com/aksdb/caddy-cgi?tab=readme-ov-file#execute-dynamic-script
          cgi /*.cgi ${pkgs.nagios}/sbin{path} {
            env NAGIOS_CGI_CONFIG=/etc/nagios/nagios.cgi.conf REMOTE_USER=nagiosadmin
          }
        }

        handle_path ${urlPath}/* {
          root * ${pkgs.nagios}/share
          php_fastcgi unix//${config.services.caddy.phpFpmSock}
          file_server
        }
        redir / /nagios/
        redir /nagios /nagios/
      }

      log {
        format console
        output file ${config.services.caddy.logPath}/nagios.log
      }
    }
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

  nsca = (import ./nagios/nsca.nix) { inherit pkgs; };
  # TODO Test
  # echo -e "host-name\nasdasd\n0\n1\n" | send_nsca 127.0.0.1 -p 5667 -c /etc/nagios/send_nsca.conf
  nscaConfig = pkgs.writeText "nsca.conf" ''
    pid_file=${cfg.nsca.pid_file}
    server_port=${toString cfg.nsca.server_port}
    server_address=${cfg.nsca.server_address}
    nsca_user=${cfg.nsca.user}
    nsca_group=${cfg.nsca.group}
    debug=${toString cfg.nsca.debug}
    command_file=${cfg.nsca.command_file}
  '';
  sendNscaConfig = pkgs.writeText "send_nsca.cfg" ''

'';
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

      package = mkOption {
        description = "Package to be used for nagios";
        default = pkgs.nagios;
      };
      nsca = {
        enable = mkEnableOption "Enable nagios nsca";
        package = mkOption {
          description = "Package to be used for nsca";
          default = nsca;
        };
        config_file = mkOption {
          description = "Location of nsca config file";
          default = "/etc/nagios/nsca.conf";
        };
        pid_file = mkOption {
          description = "Location of pid file";
          default = "${nagiosNscaState}/nsca.pid";
        };
        user = mkOption {
          type = types.str;
          description = "User name for nsca";
          default = "nagios-nsca";
        };
        group = mkOption {
          type = types.str;
          description = "Group name for nsca";
          default = "nagios-nsca";
        };
        server_port = mkOption {
          type = types.int;
          description = "Port where to serve nsca";
          default = 5667;
        };
        server_address = mkOption {
          type = types.str;
          description = "Host name where to serve nsca";
          default = "127.0.0.1";
        };
        debug = mkOption {
          type = types.int;
          description = "Pass 1 to enable debug";
          default = 0;
        };
        command_file = mkOption {
          type = types.str;
          default = "${nagiosRw}/nagios.cmd";
        };
        send_shortcut = mkOption {
          description = "Nix function that generates nsca bash invocation";
          default = host: service: code: message: "echo -e '${host}\t${service}\t${toString code}\t${message}' | ${nsca}/bin/send_nsca ${cfg.nsca.server_address} -p ${toString cfg.nsca.server_port} -c ${cfg.nsca.config_file}";
        };
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
    users.users.nagios-nsca = {
      description = "Nagios NSCA user";
      uid = 1108;
      home = nagiosNscaState;
      gid = 1108;
      isHidden = true;
    };
    users.knownUsers = [ "nagios" "nagios-nsca" ];

    users.groups.nagios = { gid = 1100; };
    users.groups.nagios-cmd = {
      gid = 1106;
      # Allow cgi file to write to nagios.cmd file
      # https://web.archive.org/web/20220327165441/http://nagios.manubulon.com/traduction/docs14en/commandfile.html
      members = [ "nagios" "caddy" "nagios-nsca" ];
    };
    users.groups.nagios-nsca = { gid = 1108; };
    users.knownGroups = [ "nagios" "nagios-cmd" "nagios-nsca" ];

    # This isn't needed, it's just so that the user can type "nagiostats
    # -c /etc/nagios.cfg".
    environment.etc."nagios/nagios.cfg".source = nagiosCfgFile;

    # NSCA
    # https://github.com/NagiosEnterprises/nsca/blob/master/sample-config/nsca.cfg.in
    environment.etc."nagios/nsca.conf".source = nscaConfig;
    environment.etc."nagios/send_nsca.conf".source = sendNscaConfig;
    environment.etc."nagios/nagios.cgi.conf".source = cfg.cgiConfigFile;

    services.newsyslog.modules.nagios = {
      "${nagiosLogDir}/stdout.log" = {
        owner = "nagios";
        group = "nagios";
        mode = "600";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
      "${nagiosLogDir}/stderr.log" = {
        owner = "nagios";
        group = "nagios";
        mode = "600";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
      "${nagiosNscaLogDir}/nsca.stdout.log" = {
        owner = "nagios-nsca";
        group = "nagios-nsca";
        mode = "600";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
      "${nagiosNscaLogDir}/nsca.stderr.log" = {
        owner = "nagios-nsca";
        group = "nagios-nsca";
        mode = "600";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
    };

    services.caddy.enablePhp = mkIf cfg.enableWebInterface true;
    services.caddy.extraConfig = caddyConfig;

    environment.systemPackages = [ cfg.package pkgs.monitoring-plugins cfg.nsca.package ];
    launchd.daemons.nagios = {
      # Make sure that nagios can use curl to send things to ntfy-sh
      path = [ pkgs.curl cfg.package ] ++ cfg.plugins;

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
      command = "nagios /etc/nagios/nagios.cfg";
    };


    launchd.daemons.nagios-nsca = {
      path = [ cfg.nsca.package ];
      serviceConfig = {
        UserName = "nagios-nsca";
        GroupName = "nagios-nsca";
        KeepAlive = true;
        StandardOutPath = "${nagiosNscaLogDir}/nsca.stdout.log";
        StandardErrorPath = "${nagiosNscaLogDir}/nsca.stderr.log";
        WorkingDirectory = nagiosNscaState;
      };
      command = "nsca -f -c ${cfg.nsca.config_file}";
    };

    system.activationScripts.postActivation = {
      text = ''
        echo "Ensuring nagios directories exist"
        mkdir -vp ${nagiosLogDir} ${nagiosState} ${nagiosRw}
        chown -v nagios:nagios ${nagiosLogDir}
        chown -v nagios:nagios-cmd ${nagiosState} ${nagiosRw}
        chmod -v u+rwx,g=rx,o= ${nagiosState}
        echo "Ensuring nagios-cmd group can access ${nagiosRw}"
        chmod -v ug+rwx,g+s,o= ${nagiosRw}

        echo "Restarting nagios"
        launchctl kickstart -k system/${config.launchd.labelPrefix}.nagios

        mkdir -vp ${nagiosNscaState} ${nagiosNscaLogDir}
        chown -v nagios-nsca:nagios-nsca ${nagiosNscaState} ${nagiosNscaLogDir}
        echo "Restarting nagios-nsca"
        launchctl kickstart -k system/${config.launchd.labelPrefix}.nagios-nsca
      '';
    };
  };
}
