# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function mcd --description "Make a dir, cd there" --argument dest
    mkdir -v -p $dest || return
    cd $dest || return
end
