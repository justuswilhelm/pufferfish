{ pkgs, ... }: {
  home.packages = [
    pkgs.hledger
    pkgs.khal
    pkgs.khard
  ];
}
