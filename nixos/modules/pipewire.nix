{ pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  environment.systemPackages = [ pkgs.pavucontrol ];
}
