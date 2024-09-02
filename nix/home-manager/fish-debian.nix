# Fish login shell nix path workaround for Debian
{ ... }:
{
  programs.fish.loginShellInit = ''
    # Only need to source this once
    source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
  '';
}
