{ config, lib, pkgs, ... }:
let
  radicaleState = "/var/lib/radicale";
  logPath = "/var/log/radicale";

  radicale = pkgs.radicale;
  radicaleConfig = pkgs.writeText "config" (lib.generators.toINI { } {
    server = {
      hosts = "127.0.0.1:18110";
    };

    auth = {
      type = "htpasswd";
      htpasswd_filename = "${radicaleState}/users";
      htpasswd_encryption = "bcrypt";
    };

    storage = {
      filesystem_folder = "${radicaleState}/collections";
    };
  });
in
{
  users.groups.radicale = { gid = 1020; };
  users.users.radicale = {
    description = "Radicale User";
    gid = 1020;
    uid = 1020;
    isHidden = true;
  };
  users.knownGroups = [ "radicale" ];
  users.knownUsers = [ "radicale" ];

  environment.etc."radicale/config".source = radicaleConfig;

  environment.etc."newsyslog.d/radicale.conf".text = ''
    # logfilename                  [owner:group]     mode count size when  flags [/pid_file] [sig_num]
    ${logPath}/radicale.stdout.log radicale:radicale 640  10    *    $D0   J
    ${logPath}/radicale.stderr.log radicale:radicale 640  10    *    $D0   J
  '';

  environment.systemPackages = [ radicale ];
  launchd.daemons.radicale = {
    command = "${radicale}/bin/radicale";
    serviceConfig = {
      KeepAlive = true;
      StandardOutPath = "${logPath}/radicale.stdout.log";
      StandardErrorPath = "${logPath}/radicale.stderr.log";
      UserName = "radicale";
      GroupName = "radicale";
    };
  };
  system.activationScripts.postActivation = {
    text = ''
      echo "Ensuring radicale directories exist"
      sudo mkdir -p ${radicaleState} ${logPath}
      sudo chown radicale:radicale ${radicaleState} ${logPath}
      sudo chmod go= ${radicaleState}
      echo "Restarting radicale"
      launchctl kickstart -k system/${config.launchd.labelPrefix}.radicale
    '';
  };
}

