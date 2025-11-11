# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Programs used to interact with the web
{ ... }: {
  home.packages = [
    pkgs.httrack
    pkgs.curl
    pkgs.wget
  ];
}
