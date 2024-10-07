# Use attic on lithium.local
{ ... } :
let
  cache-url = "https://lithium.local:10100/lithium-default";
in
{
  # Derived from running attic use lithium-default
  nix.settings.substituters = [ cache-url ];
  nix.settings.trusted-public-keys = [
    "lithium-default:12m8tx3dPRBH0y4Gf6t/4eGh7Y8AJ7r2TT0Ug/w9Wvo="
  ];
  nix.settings.trusted-substituters = [ cache-url ];
  nix.settings.netrc-file = "/etc/nix/netrc";

  security.pki.certificateFiles = [
    ../../lithium-ca.crt
  ];
}
