{ pkgs, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  config = {
    source_directories = [ "/etc" "/opt" "/Applications" "/Library" "/Users" ];
    exclude_patterns = [ "/Users/*/.cache" "/Users/*/Library/Caches" "/Users/*/Movies" ];
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

  logPath = "/var/log/borgmatic/borgmatic.log";
  borgmatic = pkgs.borgmatic;
in
{
  environment.systemPackages = [
    borgmatic
  ];

  environment.etc."borgmatic/base/borgmatic_base.yaml".source =
    yamlFormat.generate "borgmatic_base.yaml" config;

  launchd.daemons.borgmatic = {
    command = "${borgmatic}/bin/borgmatic --log-file-verbosity 2 --log-file ${logPath}";
    serviceConfig = {
      # Performance
      ProcessType = "Background";
      LowPriorityBackgroundIO = true;
      LowPriorityIO = true;

      # Timing
      StartCalendarInterval = [{ Minute = 0; }];
    };
  };
}
