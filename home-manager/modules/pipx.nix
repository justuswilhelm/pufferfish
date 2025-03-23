{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.pipx
  ];

  # Ensure .local/bin is in PATH for pipx installed apps
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];
}
