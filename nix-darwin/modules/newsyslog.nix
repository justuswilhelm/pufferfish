# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.newsyslog;

  mkLine = path: conf:
    let
      # The colon must be included even if you only specify owner or group,
      # but not both
      owner = if conf.owner != null then conf.owner else "";
      group = if conf.group != null then conf.group else "";
      ownerGroup =
        if (conf.owner == null) && (conf.group == null) then
          ""
        else
          "${owner}:${group}";
      flags = if conf.flags != null then conf.flags else "";
    in
    concatStringsSep " " [
      path
      ownerGroup
      conf.mode
      (toString conf.count)
      conf.size
      conf.when
      flags
      # TODO
      # path_to_pid_file
      # signal_number
    ];

  mkFile = name: moduleConf:
    let
      lines = mapAttrsToList mkLine moduleConf;
    in
    {
      text = ''
        # logfilename                   [owner:group]    mode count size when  flags [/pid_file] [sig_num]
        ${concatStringsSep "\n" lines}
      '';
    };
in
{
  options = {
    services.newsyslog = {
      modules = mkOption {
        default = { };
        type = types.attrsOf (types.attrsOf (types.submodule {
          options = {
            owner = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "User that new log file belongs to. Defaults to root";
            };

            group = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Group that new log file belongs to. Defaults to admin";
            };

            mode = mkOption {
              type = types.str;
              description = "File mode of the log file and archives.";
              example = "640";
            };

            count = mkOption {
              type = types.int;
              description = "Maximum number of archive files which may exist. Does not consider current log file.";
              example = 10;
            };

            size = mkOption {
              type = types.str;
              default = "*";
              description = "Size threshold for rotation. Specify '*' for any size.";
            };

            when = mkOption {
              type = types.str;
              default = "$D0";
              description = "When to rotate the log file. Defaults to midnight ($D0).";
            };

            flags = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Flags for log rotation behavior.";
            };

          };
        }));
        description = "Newsyslog configuration for log rotation by module. See `man newsyslog.conf`";
        example = literalExpression ''
          {
            myapp = {
              "/var/log/myapp.log" = {
                mode = "640";
                count = 10;
                size = "1000";
                when = "$D0";
                flags = "J";
              };
            };
          }
        '';
      };
    };
  };

  config = mkIf (cfg.modules != { }) {
    environment.etc = mapAttrs'
      (name: conf: { name = "newsyslog.d/${name}.conf"; value = mkFile name conf; })
      cfg.modules;
  };
}
