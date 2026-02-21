# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mpd;
  mpdLogPath = "/Users/${config.system.primaryUser}/Library/Logs/mpd/mpd.log";
  ympdLogPath = "/Users/${config.system.primaryUser}/Library/Logs/mpd/ympd.log";

  # Internal ports
  streamPort = 20300;
  mpdPort = 6600;
  webPort = 18080;

  # External
  caddyHost = "lithium.local";
  caddyPort = 10200;

  mpdConfigFile = pkgs.writeText "mpd.conf" ''
    music_directory    "${cfg.musicDirectory}"
    playlist_directory "${cfg.dataDir}/playlists"
    db_file            "${cfg.dataDir}/database"
    log_file           "${cfg.dataDir}/log"
    pid_file           "${cfg.dataDir}/pid"
    state_file         "${cfg.dataDir}/state"
    sticker_file       "${cfg.dataDir}/sticker.sql"

    bind_to_address    "127.0.0.1"
    port               "${toString mpdPort}"

    max_output_buffer_size "32768"

    audio_output {
        type           "osx"
        name           "CoreAudio"
        mixer_type     "software"
    }

    audio_output {
        type           "httpd"
        name           "httpd on port ${toString streamPort}"
        always_on "yes"
        encoder        "flac"
        port           "${toString streamPort}"
        bind_to_address "localhost"
        bitrate        "192"
        format         "44100:16:2"
        max_clients    "0"
    }
  '';
in
{
  options.services.mpd = {
    musicDirectory = lib.mkOption {
      type = lib.types.str;
      default = "~/annex/Music/Music_Files/";
      description = "Directory containing music files";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "~/.config/mpd";
      description = "Base directory for MPD configuration and data files";
    };
  };

  config = {
    environment.etc."mpd.conf".source = mpdConfigFile;
    environment.systemPackages = [
      pkgs.mpc
      pkgs.ashuffle
      pkgs.rmpc
    ];

    services.caddy.extraConfig = ''
    # MPD Web Interface and Stream
    https://${caddyHost}:${toString caddyPort} {
      import certs

      handle_path /stream {
        reverse_proxy localhost:${toString streamPort}
      }

      handle /* {
        reverse_proxy localhost:${toString webPort}
      }

      log {
        format console
        output file ${config.services.caddy.logPath}/mpd.log
      }
    }
  '';

    services.newsyslog.modules.mpd = {
      ${mpdLogPath} = {
        owner = config.system.primaryUser;
        mode = "600";
        count = 10;
        when = "$D0";
        flags = "J";
      };
      ${ympdLogPath} = {
        owner = config.system.primaryUser;
        mode = "600";
        count = 10;
        when = "$D0";
        flags = "J";
      };
    };

    launchd.user.agents.mpd = {
      path = [
        pkgs.mpd
        pkgs.moreutils
      ];
      script = ''
        exec ${pkgs.mpd}/bin/mpd --no-daemon --stderr /etc/mpd.conf 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
      '';
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = mpdLogPath;
        ProcessType = "Interactive";
      };
    };

    launchd.user.agents.ympd = {
      path = [
        pkgs.ympd
        pkgs.moreutils
      ];
      script = ''
        exec ${pkgs.ympd}/bin/ympd --host localhost --port ${toString mpdPort} --webport ${toString webPort} 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
      '';
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = ympdLogPath;
      };
    };
  };
}
