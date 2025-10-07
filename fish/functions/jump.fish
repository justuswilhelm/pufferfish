# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function jump -d "Jump to a directory" -a query
    # If we are inside a git repo we want to jump relative to current dir
    if git rev-parse --is-inside-work-tree &>/dev/null
        set where (git rev-parse --show-toplevel)
    else
        set where $PWD
    end

    set dir (fzf-from-jump-history --where=$where --query=$query)

    cd $dir
end
