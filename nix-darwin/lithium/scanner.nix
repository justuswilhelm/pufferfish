# SPDX-FileCopyrightText: 2026 Justus Perlwitz
# SPDX-License-Identifier: GPL-3.0-or-later

{
  pkgs,
  lib,
  config,
  ...
}:
let
  logPath = "/Users/${config.system.primaryUser}/Library/Logs/scansnap/scansnap.log";
  scanSnapApp = "/Applications/ScanSnapHomeMain.app";
  # See https://stackoverflow.com/questions/13987671/launchd-plist-runs-every-10-seconds-instead-of-just-once/49902760#49902760:~:text=gcc%20%2Dframework%20Foundation%20%2Do%20xpc%5Fset%5Fevent%5Fstream%5Fhandler%20xpc%5Fset%5Fevent%5Fstream%5Fhandler%2Em
  xpcHandler = pkgs.runCommandCC "xpc_set_event_stream_handler" { } ''
    mkdir $out $out/bin
    cc -framework Foundation \
       -o $out/bin/xpc_set_event_stream_handler \
       ${./xpc_set_event_stream_handler.m}
  '';
in
{
  services.newsyslog.modules.scansnap-ix1300-attach = {
    ${logPath} = {
      owner = config.system.primaryUser;
      mode = "600";
      count = 10;
      when = "$D0";
      flags = "J";
    };
  };

  launchd.user.agents.scansnap-ix1300-attach = {
    path = [ pkgs.moreutils ];
    script = ''
      (
        exec ${xpcHandler}/bin/xpc_set_event_stream_handler \
          /usr/bin/open -a ${scanSnapApp}
      ) 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
    '';
    serviceConfig = {
      StandardOutPath = logPath;
      KeepAlive = false;
      # See
      # https://github.com/snosrap/xpc_set_event_stream_handler
      LaunchEvents = {
        "com.apple.iokit.matching" = {
          "com.apple.device-attach" = {
            # Run this to find the IDs:
            # system_profiler SPUSBDataType | grep ScanSnap -A20
            idProduct = lib.trivial.fromHexString "162c";
            # Fujitsu Ltd vendor id
            # See https://devicehunt.com/view/type/usb/vendor/04C5
            idVendor = lib.trivial.fromHexString "04c5";
            IOProviderClass = "IOUSBDevice";
            IOMatchLaunchStream = true;
          };
        };
      };
    };
  };
}
