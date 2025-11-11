#!/usr/bin/env sh
# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Format lua scripts inside my dotfiles
set -e

lua-format --in-place "$DOTFILES"/nvim/**.lua
