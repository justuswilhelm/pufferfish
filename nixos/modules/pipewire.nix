{ pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # For supercollider
    jack.enable = true;
  };

  security.rtkit.enable = true;
  environment.systemPackages = [
    pkgs.pavucontrol
    pkgs.pulseaudioFull
    pkgs.qjackctl
  ];
}
