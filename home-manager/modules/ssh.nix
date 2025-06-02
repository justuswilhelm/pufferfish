{ pkgs, ... }:
{
  home.packages = [
    pkgs.mosh
  ];
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraOptionOverrides = {
      ConnectTimeout = "5";
      IdentitiesOnly = "yes";
      # Avoid leaking our current user name
      # User = "root";
      # Avoid being prompted for password. Re-enable if needed for specific
      # hosts
      PasswordAuthentication = "no";
    };
  };
}
