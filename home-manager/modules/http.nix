# Programs used to interact with the web
{ ... } : {
  home.packages = [
    pkgs.httrack
    pkgs.curl
    pkgs.wget
  ];
}
