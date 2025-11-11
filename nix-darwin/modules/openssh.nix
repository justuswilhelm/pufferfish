# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# TODO make this a Nix module
{ ... }:
{
  # This file
  # https://github.com/LnL7/nix-darwin/blob/8c8388ade72e58efdeae71b4cbb79e872c23a56b/modules/programs/ssh/default.nix#L92
  # causes an issue when other devices connect and I want to use my own authorized
  # keys file.
  # Log output
  # XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 0xFFFFFF   Info        0x0                  9999   0    sshd: AuthorizedKeysCommand /bin/cat /etc/ssh/nix_authorized_keys.d/$USER failed, status 1
  # TODO check if this workaround is still necessaryb
  environment.etc."ssh/sshd_config.d/101-authorized-keys.conf".enable = false;
  #   environment.etc."ssh/sshd_config.d/keys".text = ''
  #     AuthorizedKeysFile /Users/%u/.ssh/authorized_keys
  #   '';
  environment.etc."ssh/sshd_config.d/200-harden.conf".text = ''
    PermitRootLogin no

    # Only let users log in with ssh key
    PubkeyAuthentication yes
    PasswordAuthentication no
    # And no password
    PermitEmptyPasswords no
    KbdInteractiveAuthentication no

    # Use PAM to populate user env
    UsePAM yes

    # Disable sftp
    # https://serverfault.com/a/817482
    Subsystem sftp /bin/false
  '';
  environment.etc."ssh/sshd_config.d/300-log.conf".text = ''
    SyslogFacility AUTH
    LogLevel INFO
  '';
}
