{ pkgs, config, ... }:
let
  borgmatic = pkgs.borgmatic;
  statePath = "/var/lib/borgmatic";
  logPath = "/var/log/borgmatic";

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
    encryption_passcommand = "${pkgs.coreutils}/bin/cat ${statePath}/passphrase";
    ssh_command = "ssh -o 'UserKnownHostsFile=${statePath}/ssh/known_hosts' -i${statePath}/ssh/id_rsa";
    borg_base_directory = statePath;
    borg_config_directory = "${statePath}/config";
    borg_cache_directory = "${statePath}/cache";
    borg_security_directory = "${statePath}/security";

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

  # Let borgmatic run for 2h max
  timeout = 60 * 60 * 2;
  # Kill after not responding to SIGINT
  killAfter = 2 * 60;
in
{
  environment.systemPackages = [ borgmatic ];

  environment.etc."borgmatic/base/borgmatic_base.yaml".source = borgmaticConfigYaml;
  # Copied from /etc/newsyslog.d/wifi.conf
  environment.etc."newsyslog.d/borgmatic.conf".text = ''
    # logfilename            [owner:group]    mode count size when  flags [/pid_file] [sig_num]
    ${logPath}/borgmatic.log                  640  10    *    $D0   J
  '';

  launchd.daemons.borgmatic = {
    path = [ borgmatic pkgs.coreutils config.services.nagios.nsca-package ];
    # Kill after 120 seconds of not reacting to SIGINT
    command = "timeout --kill-after=${toString killAfter}s --signal INT ${toString timeout}s borgmatic --log-file-verbosity 2 --log-file ${logPath}/borgmatic.log";
    serviceConfig = {
      # Performance
      ProcessType = "Background";
      LowPriorityBackgroundIO = true;
      # Maybe:
      # NetworkState = true;
      # So that we don't try to back up when not connected to the network
      LowPriorityIO = true;
      # Timing
      StartCalendarInterval = [{ Minute = 0; }];
    };
  };

  system.activationScripts.preActivation = {
    text = ''
      mkdir -p ${logPath} ${statePath}
      chmod -R go= ${statePath}
    '';
  };

}
