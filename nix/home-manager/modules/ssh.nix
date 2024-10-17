{ ... }:
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraOptionOverrides = {
      IdentitiesOnly = "yes";
      IdentityFile = "/dev/null";
      # Avoid leaking our current user name
      User = "root";
      # Avoid being prompted for password. Re-enable if needed for specific
      # hosts
      PasswordAuthentication = "no";
    };
  };
}
