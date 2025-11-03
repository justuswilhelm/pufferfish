# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

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
