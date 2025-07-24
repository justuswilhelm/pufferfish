{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sync-git-annex;
in
{
  options.services.sync-git-annex = {
    enable = mkEnableOption "sync-git-annex service";
  };

  # should be a user agent
  config = mkIf cfg.enable {
    launchd.daemons.sync-git-annex = {
      path = [ pkgs.fish ];
      script = ''
        fish -l sync-git-annex
      '';
      serviceConfig = {
        StartCalendarInterval = [{ Minute = 0; }];
        UserName = config.system.primaryUser;
      };
    };
  };
}
