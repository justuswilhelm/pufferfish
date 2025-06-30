{ config, pkgs, lib, ... }:
let
  cfg = config.services.borgmatic;
  yamlFormat = pkgs.formats.yaml { };
  # Share this with other modules
  # Or use nixos configuration module
  borgmatic-config = {
    source_directories = [ "/home" "/etc" "/var" ];
    exclude_patterns = cfg.extra_exclude_patterns;
    encryption_passcommand = "${pkgs.coreutils}/bin/cat /etc/borgmatic/passphrase";
    ssh_command = "ssh -i /etc/borgmatic/id_rsa";
    keep_hourly = 6;
    keep_daily = 7;
    keep_weekly = 4;
    keep_monthly = 6;
    keep_yearly = 1;

    checks = [
      { name = "repository"; frequency = "1 month"; }
      { name = "archives"; frequency = "1 month"; }
    ];
    check_last = 10;
  };
  srv-borgbackup-config = {
    repositories = [
      {
        label = "srv-borgbackup";
        path = "/srv/borgbackup/${config.networking.hostName}";
      }
    ];
  } // borgmatic-config;
in
{
  options = {
    services.borgmatic.extra_exclude_patterns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional patterns to exclude from borgmatic backups";
    };
  };
  config = {
    services.borgmatic = {
      enable = true;
    };
    environment.etc."borgmatic/base/borgmatic_base.yaml".source =
      yamlFormat.generate "borgmatic_base.yaml" borgmatic-config;
    environment.etc."borgmatic.d/srv-borgbackup.yaml".source =
      yamlFormat.generate "srv-borgbackup.yaml" srv-borgbackup-config;
  };
}
