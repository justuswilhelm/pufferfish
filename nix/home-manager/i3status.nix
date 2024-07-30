{ isLaptop }:
let
  laptopOnly =
    if isLaptop then {
      "battery 0" = {
        settings = {
          format = "%status %percentage %remaining %emptytime";
          format_down = "No battery";
          status_chr = "⚡ CHR";
          status_bat = "🔋 BAT";
          status_unk = "? UNK";
          status_full = "☻ FULL";
          path = "/sys/class/power_supply/BAT%d/uevent";
          low_threshold = 10;
        };
        position = 7;
      };
    } else { };
in
{
  general =
    {
      output_format = "i3bar";
      interval = 5;
    };

  modules = {
    "ethernet enp7s0" = {
      settings = {
        format_up = "enp7s0: %ip (%speed)";
        format_down = "enp7s0: down";
      };
      position = 0;
    };

    "disk /" = {
      settings = {
        format = "/ %free";
      };
      position = 1;
    };

    "disk /home" = {
      settings = {
        format = "/home %free";
      };
      position = 2;
    };

    load = {
      settings = {
        format = "load: %1min, %5min, %15min";
      };
      position = 3;
    };

    memory = {
      settings = {
        format = "f: %free a: %available u: %used t: %total";
        threshold_degraded = "10%";
        format_degraded = "MEMORY: %free";
      };
      position = 4;
    };

    "tztime UTC" = {
      settings = {
        format = "UTC %Y-%m-%d %H:%M:%S";
        timezone = "UTC";
      };
      position = 5;
    };

    "tztime local" = {
      settings = {
        format = "LCL %Y-%m-%d %H:%M:%S %Z";
      };
      position = 6;
    };
  } // laptopOnly;
}
