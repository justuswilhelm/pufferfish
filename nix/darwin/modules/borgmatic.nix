{ pkgs, ... }:
let
  borgmatic = pkgs.borgmatic;

  borgmaticConfig = {
    source_directories = [ "/etc" "/opt" "/Applications" "/Library" "/Users" "/var" ];
    exclude_patterns = [ "/Users/*/.cache" "/Users/*/Library/Caches" "/Users/*/Movies" ];
    encryption_passcommand = "${pkgs.coreutils}/bin/cat /etc/borgmatic/passphrase";
    ssh_command = "ssh -i /etc/borgmatic/id_rsa";
    keep_hourly = 6;
    keep_daily = 7;
    keep_weekly = 4;
    keep_monthly = 6;
    keep_yearly = 1;
    repositories = [];

    checks = [
      { name = "repository"; frequency = "1 month"; }
      { name = "archives"; frequency = "1 month"; }
    ];
    check_last = 10;
  };
  borgmaticConfigYaml = let
    yamlFormat = pkgs.formats.yaml { };
    cfg = yamlFormat.generate "borgmatic_base.yaml" borgmaticConfig;
validated = pkgs.runCommand "borgmatic_base_checked.yml" { preferLocalBuild = true;} ''
      cp ${cfg} borgmatic_base.yml
      ${borgmatic}/bin/borgmatic config validate \
        --config borgmatic_base.yml && cp ${cfg} $out

    '';
  in validated;

  logPath = "/var/log/borgmatic/borgmatic.log";
in
{
  environment.systemPackages = [
    borgmatic
  ];

  environment.etc."borgmatic/base/borgmatic_base.yaml".source = borgmaticConfigYaml;

  launchd.daemons.borgmatic = {
    path = [ borgmatic ];
    command = "borgmatic --log-file-verbosity 2 --log-file ${logPath}";
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
