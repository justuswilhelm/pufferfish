#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# This xbar plugin shows you the state of your Pomoglorbo timer
#
# Metadata allows your plugin to show up in the app, and website.
#
#  <xbar.title>Pomoglorbo xbar</xbar.title>
#  <xbar.version>v1.0</xbar.version>
#  <xbar.author>Justus Perlwitz</xbar.author>
#  <xbar.desc>Render pomoglorbo status</xbar.desc>
#  <xbar.abouturl>http://url-to-about.com/</xbar.abouturl>
cat ~/.local/state/pomoglorbo/state.pomoglorbo
