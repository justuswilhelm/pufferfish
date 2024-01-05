let
  username = "justusperlwitz";
  in
{ pkgs, ... }: {
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
