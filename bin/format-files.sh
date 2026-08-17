#!/usr/bin/env sh
# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Format lua scripts inside my dotfiles
set -e

find "$DOTFILES/nvim" -name '*.lua' -print0 | xargs -0 lua-format --verbose --in-place

find "$DOTFILES/fish" -name '*.fish' -print0 | xargs -0 -I % fish -c "fish_indent -w %"

prettier -w .
