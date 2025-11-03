# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, ... }: {
  # References:
  # rsyslogd -> fluentd
  # https://www.fluentd.org/guides/recipes/rsyslogd-aggregation
  # rsyslogd nix file
  # https://github.com/NixOS/nixpkgs/blob/1546c45c538633ae40b93e2d14e0bb6fd8f13347/nixos/modules/services/logging/rsyslogd.nix
  services.rsyslogd = {
    enable = true;
    defaultConfig = ''
      *.* @127.0.0.1:5140
    '';
  };
  services.journald.forwardToSyslog = true;
  services.fluentd = {
    enable = true;
    config = ''
      <source>
        @type syslog
        port 5140
        bind 127.0.0.1
        tag system
      </source>
      <match system.**>
        @type s3

        aws_key_id "#{ENV['AWS_KEY_ID']}"
        aws_sec_key "#{ENV['AWS_SEC_KEY']}"
        s3_bucket fluentd
        s3_region garage
        s3_endpoint http://127.0.0.1:3900
        path logs/
        <buffer tag,time>
          @type file
          path /var/lib/fluentd/s3_buffer
          timekey 3600 # 1 hour partition
          timekey_wait 10m
          timekey_use_utc true # use utc
          chunk_limit_size 256m
        </buffer>
      </match>
    '';
  };
  systemd.services.fluentd.serviceConfig = {
    DynamicUser = true;
    StateDirectory = "fluentd";
    ProtectHome = true;
    NoNewPrivileges = true;
    # Store the keys that you get from garage under
    # AWS_KEY_ID
    # AWS_SEC_KEY
    EnvironmentFile = "/var/lib/fluentd-secrets/env";
  };

  # https://search.nixos.org/options?channel=24.11&show=services.garage.enable&from=0&size=50&sort=relevance&type=packages&query=garage
  services.garage = {
    enable = true;
    package = pkgs.garage_1_x;
    environmentFile = "/var/lib/garage-secrets/env";
    # TODO disable this soon
    logLevel = "debug";
    extraEnvironment = {
      RUST_BACKTRACE = "1";
    };
    settings = {
      db_engine = "sqlite";
      replication_factor = 1;
      rpc_bind_addr = "[::]:3901";
      rpc_public_addr = "127.0.0.1:3901";
      s3_api = {
        s3_region = "garage";
        api_bind_addr = "127.0.0.1:3900";
        root_domain = ".s3.garage.localhost";
      };
      k2v_api = {
        api_bind_addr = "[::]:3904";
      };
      admin = {
        api_bind_addr = "127.0.0.1:3903";
      };
    };
  };
  system.activationScripts.garage = ''
    if [[ ! -e /var/lib/garage-secrets ]] ; then
      mkdir -m 700 /var/lib/garage-secrets
    fi
    if [[ ! -e /var/lib/garage-secrets/env ]] ; then
      echo "GARAGE_RPC_SECRET=$(openssl rand -hex 32)
      GARAGE_ADMIN_TOKEN=$(openssl rand -hex 32)
      GARAGE_METRICS_TOKEN=$(openssl rand -hex 32)" > /var/lib/garage-secrets/env
      chmod 400 /var/lib/garage-secrets/env
    fi
  '';
}
