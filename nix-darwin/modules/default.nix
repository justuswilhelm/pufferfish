# This imports all the modules that use .enable Nix module semantics
# You can import this on all Nix Darwin machines and be guaranteed that they
# don't do anything you don't want if you don't explicitly set .enable to
# true for a module.
{ ... }:
{
  imports = [
    ../modules/borgmatic.nix
    ../modules/nagios.nix
    ../modules/newsyslog.nix
    ../modules/sync-git-annex.nix
    ../modules/vdirsyncer.nix
  ];
}
