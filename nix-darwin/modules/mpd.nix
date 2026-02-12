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

  mpdConfigFile = pkgs.writeText "mpd.conf" ''
    music_directory    "${cfg.musicDirectory}"
    playlist_directory "${cfg.dataDir}/playlists"
    db_file            "${cfg.dataDir}/database"
    log_file           "${cfg.dataDir}/log"
    pid_file           "${cfg.dataDir}/pid"
    state_file         "${cfg.dataDir}/state"
    sticker_file       "${cfg.dataDir}/sticker.sql"

    bind_to_address    "localhost"
    port               "${toString cfg.port}"

    max_output_buffer_size "32768"

    audio_output {
        type           "osx"
        name           "CoreAudio"
        mixer_type     "software"
    }
  '';
in
{
  options.services.mpd = {
    port = lib.mkOption {
      type = lib.types.port;
      default = 6600;
      description = "Port for MPD to listen on";
    };

    webPort = lib.mkOption {
      type = lib.types.port;
      default = 18080;
      description = "Port for YMPD web interface";
    };

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
    ];

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
      path = [ pkgs.mpd pkgs.moreutils ];
      script = ''
        exec ${pkgs.mpd}/bin/mpd --no-daemon --stderr /etc/mpd.conf 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
      '';
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = mpdLogPath;
      };
    };

    launchd.user.agents.ympd = {
      path = [ pkgs.ympd pkgs.moreutils ];
      script = ''
        exec ${pkgs.ympd}/bin/ympd --host localhost --port ${toString cfg.port} --webport ${toString cfg.webPort} 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
      '';
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = ympdLogPath;
      };
    };
  };
}
