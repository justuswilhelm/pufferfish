{ ... }:
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraOptionOverrides = {
      IdentitiesOnly = "yes";
      IdentityFile = "/dev/null";
    };
  };
}
