{ config, lib, pkgs, ... }:
let
  nsca = (import ../../darwin/modules/nagios/nsca.nix) { inherit pkgs; };
  sendNscaConfig = pkgs.writeText "send_nsca.cfg" ''

'';
in
{
  environment.etc."nagios/send_nsca.conf".source = sendNscaConfig;
  environment.systemPackages = [
    nsca
  ];
}
