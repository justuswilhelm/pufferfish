{ pkgs, config, ... }:
let
  borgmatic = pkgs.borgmatic;

  borgmaticConfig = {
    source_directories = [
      "/etc"
      "/Applications"
      "/Library"
      "/Users"
      "/var"
    ];
    exclude_patterns = [
      "/Library/Developer"
      "/Library/Updates"
      "/Users/*/.Trash"
      "/Users/*/.cache"
      "/Users/*/Library/Caches"
      "/Users/*/Library/Developer/CoreSimulator/Caches/*"
      "/Users/*/Movies"
    ];
    encryption_passcommand = "${pkgs.coreutils}/bin/cat /var/root/.borgmatic/passphrase";
    ssh_command = "ssh -i /var/root/.borgmatic/id_rsa";
    keep_hourly = 6;
    keep_daily = 7;
    keep_weekly = 4;
    keep_monthly = 6;
    keep_yearly = 1;
    repositories = [ ];

    checks = [
      { name = "repository"; frequency = "1 month"; }
      { name = "archives"; frequency = "1 month"; }
    ];
    check_last = 10;
    # TODO add individual per-repository checks
    after_actions = [
      "echo -e 'lithium.local,borgmatic,0,{repository}' | send_nsca 127.0.0.1 -p 5667 -c /etc/nagios/send_nsca.conf -d ,"
    ];
    on_error = [
      "echo -e 'lithium.local,borgmatic,2,{repository}' | send_nsca 127.0.0.1 -p 5667 -c /etc/nagios/send_nsca.conf -d ,"
    ];
  };
  borgmaticConfigYaml =
    let
      yamlFormat = pkgs.formats.yaml { };
      cfg = yamlFormat.generate "borgmatic_base.yaml" borgmaticConfig;
      validated = pkgs.runCommand "borgmatic_base_checked.yml" { preferLocalBuild = true; } ''
        cp ${cfg} borgmatic_base.yml
        ${borgmatic}/bin/borgmatic config validate \
          --config borgmatic_base.yml && cp ${cfg} $out

      '';
    in
    validated;

  logPath = "/var/log/borgmatic";
in
{
  environment.systemPackages = [
    borgmatic
  ];

  environment.etc."borgmatic/base/borgmatic_base.yaml".source = borgmaticConfigYaml;

  launchd.daemons.borgmatic = {
    path = [ borgmatic config.services.nagios.nsca-package ];
    command = "borgmatic --log-file-verbosity 2 --log-file ${logPath}/borgmatic.log";
    serviceConfig = {
      # Performance
      ProcessType = "Background";
      LowPriorityBackgroundIO = true;
      # Maybe:
      # NetworkState = true;
      # So that we don't try to back up when not connected to the network
      LowPriorityIO = true;
      # Let borgmatic run for 2h max
      TimeOut = 60 * 60 * 2;

      # Timing
      StartCalendarInterval = [{ Minute = 0; }];
    };
  };

  system.activationScripts.preActivation = {
    text = ''
      mkdir -p ${logPath}
    '';
  };

}
