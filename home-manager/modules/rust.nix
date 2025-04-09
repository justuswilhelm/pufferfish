{ config, pkgs, ... }:
{
  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];
  home.packages = [
    # If pkgs.gcc is in the env as well, bad things happen with libiconv
    # and other macOS available binaries.
    pkgs.rustup
  ];
}
