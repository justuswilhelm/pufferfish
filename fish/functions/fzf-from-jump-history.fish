# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function fzf-from-jump-history -d "Fuzzy find a directory and append it to the jump history"
    argparse 'q/query=' 'w/where=' -- $argv
    or return

    if test "$_flag_where"
        set where (realpath "$_flag_where")
        echo "Assuming where=$where" >/dev/stderr
    else
        set where "$PWD"
    end

    set query "$_flag_query"

    set hist_file $XDG_STATE_HOME/pufferfish/jump.hist

    if ! mkdir -vp (dirname $hist_file)
        echo "Couldn't make directory for hist_file '$hist_file'" >/dev/stderr
        return 1
    end

    if test ! -e $hist_file
        touch $hist_file
        echo "Created new hist_file '$hist_file'" >/dev/stderr
    end

    # clean up history
    set hist_file_clean (mktemp -d)/hist_file
    for line in (cat $hist_file)
        if test -e $line
            echo $line
        else
            echo "Removing line '$line' from hist_file '$hist_file'" >/dev/stderr
            set has_cleaned_hist_file 1
        end
    end >$hist_file_clean
    if set -q has_cleaned_hist_file
        echo "Removed at least one line from hist_file '$hist_file'" >/dev/stderr
        mv -v $hist_file_clean $hist_file >/dev/stderr
    end

    if ! set dir (
        begin
            tac $hist_file | grep "$where"
            fd \
                --type directory \
                --max-depth 5 \
                . $where
        end |
        perl -ne 'print unless $seen{$_}++'  |
        fzf --scheme=history --query=$query
    )
        echo "fzf didn't exit correctly" >/dev/stderr
        return 1
    end

    if [ ! -e $dir ]
        echo "Directory $dir doesn't exist" >/dev/stderr
        return 1
    end

    if ! set rlpath (realpath $dir)/
        echo "Couldn't determine directory $dir's realpath" >/dev/stderr
        return 1
    end

    # If our path isn't in the hist file, we append it
    # Otherwise, we remove it and append it so that it becomes the last entry
    set new_hist_file (mktemp)
    begin
        grep --invert-match $rlpath $hist_file
        echo $rlpath
    end >$new_hist_file
    mv $new_hist_file $hist_file

    echo $rlpath
end
