{ specialArgs, pkgs, ... }:
{
  users.users.${specialArgs.name} = {
    isNormalUser = true;
    extraGroups = [
      # Enable sudo
      "wheel"
      # allow using virtd
      "libvirtd"
      # For serial port
      # https://wiki.nixos.org/wiki/Serial_Console#Unprivileged_access_to_serial_device
      "dialout"
    ];
    home = "/home/${specialArgs.name}";
    shell = pkgs.fish;
  };
}
