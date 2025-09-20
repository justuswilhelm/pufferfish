# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function jump -d "Jump to a directory" -a query
    # If we are inside a git repo we want to jump relative to current dir
    if git rev-parse --is-inside-work-tree &>/dev/null
        set where (git rev-parse --show-toplevel)

        if ! set dest (fd --type d . $where | fzf --scheme=path --query=$query)
            echo "Must specify destination"
            return 1
        end

        cd $dest
        return
    end

    set hist_file $XDG_STATE_HOME/pufferfish/jump.hist

    if ! mkdir -vp (dirname $hist_file)
        echo "Couldn't make directory for hist_file $hist_file"
        return 1
    end

    if test ! -e $hist_file
        touch $hist_file
    end

    if ! set dir (begin tac $hist_file; fd -t d -d 5; end | fzf --scheme=history)
        echo "Must specify destination"
        return 1
    end

    if ! set rlpath (realpath $dir)/
        echo "Could not determine directory $dir's realpath"
        return 1
    end

    if ! grep $rlpath $hist_file
        echo $rlpath >>$hist_file
    end

    cd $dir
end
