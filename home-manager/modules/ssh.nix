{ ... }:
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraOptionOverrides = {
      IdentitiesOnly = "yes";
      # Avoid leaking our current user name
      # User = "root";
      # Avoid being prompted for password. Re-enable if needed for specific
      # hosts
      PasswordAuthentication = "no";
    };
  };
}
