{ pkgs, ... }: {
  # https://github.com/drduh/YubiKey-Guide?tab=readme-ov-file#ssh
  launchd.user.agents.gpg-agent = {
    path = [ pkgs.gnupg ];
    command = "gpg-connect-agent";
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
  launchd.user.agents.gpg-agent-symlink = {
    path = [ pkgs.coreutils ];
    command = "ln -sf $HOME/.gnupg/S.gpg-agent.ssh $SSH_AUTH_SOCK";
    serviceConfig = {
      RunAtLoad = true;
    };
  };
}
