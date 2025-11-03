# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sync-git-annex;
  logPath = "/Users/${config.system.primaryUser}/Library/Logs/sync-git-annex/sync-git-annex.log";
in
{
  options.services.sync-git-annex = {
    enable = mkEnableOption "sync-git-annex service";
  };

  # should be a user agent
  config = mkIf cfg.enable {
    services.newsyslog.modules.sync-git-annex = {
      ${logPath} = {
        mode = "640";
        count = 10;
        size = "*";
        when = "$D0";
        flags = "J";
      };
    };

    launchd.user.agents.sync-git-annex = {
      path = [ pkgs.python3 pkgs.moreutils pkgs.fd pkgs.git pkgs.git-annex pkgs.openssh ];
      # TODO consider adding timeout
      script = ''
        /Users/${config.system.primaryUser}/.dotfiles/bin/sync-git-annex --non-interactive \
          2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
      '';
      serviceConfig = {
        StartCalendarInterval = [{ Minute = 0; }];
        UserName = config.system.primaryUser;
        StandardOutPath = logPath;
      };
    };
  };
}
