{ ... }:
{
  system.patches = [
    ./sshd_config.patch
  ];
  # This file
  # https://github.com/LnL7/nix-darwin/blob/8c8388ade72e58efdeae71b4cbb79e872c23a56b/modules/programs/ssh/default.nix#L92
  # causes an issue when other devices connect and I want to use my own authorized
  # keys file.
  # Log output
  # XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 0xFFFFFF   Info        0x0                  9999   0    sshd: AuthorizedKeysCommand /bin/cat /etc/ssh/nix_authorized_keys.d/$USER failed, status 1
  environment.etc."ssh/sshd_config.d/101-authorized-keys.conf".enable = false;
  #   environment.etc."ssh/sshd_config.d/keys".text = ''
  #     AuthorizedKeysFile /Users/%u/.ssh/authorized_keys
  #   '';
}
