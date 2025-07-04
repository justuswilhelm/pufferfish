# TODO make this a Nix module
# users.add_default_user = true
{ pkgs, specialArgs, ... }:
let
  uid = 501;
  name = specialArgs.name;
in
{
  users.users."${name}" = {
    description = name;
    shell = pkgs.fish;
    home = "/Users/${name}";
    inherit uid;
  };
  system.primaryUser = name;
}
