{ pkgs, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  config = {
    source_directories = [ "/home" "/etc" ];
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
in
{
  services.borgmatic = {
    enable = true;
  };
  environment.etc = {
    borgmatic_base = {
      source = yamlFormat.generate "borgmatic_base.yaml" config;
      target = "borgmatic/base/borgmatic_base.yaml";
    };
  };
}
