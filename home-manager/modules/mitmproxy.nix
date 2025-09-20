# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Infosec related packages and config
{ pkgs, ... }:
{
  home.packages = [ pkgs.mitmproxy ];
  home.file.".mitmproxy/config.yaml".source = ../../mitmproxy/config.yaml;
}
