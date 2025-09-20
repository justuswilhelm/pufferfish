# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function fn -d "Open nnn at folder chosen with fzf"
    set p (
        fd --type d \
            --strip-cwd-prefix \
            --hidden \
            --follow \
            --exclude .git |
        fzf)
    and nnn $p
end
