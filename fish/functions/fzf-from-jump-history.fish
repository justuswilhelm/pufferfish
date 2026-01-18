# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function fzf-from-jump-history -d "Fuzzy find a directory and append it to the jump history"
    argparse 'q/query=' 'w/where=' -- $argv
    or return

    if test "$_flag_where"
        set where "$_flag_where"
    else
        set where "$PWD"
    end

    set query "$_flag_query"

    set hist_file $XDG_STATE_HOME/pufferfish/jump.hist

    if ! mkdir -vp (dirname $hist_file)
        echo "Couldn't make directory for hist_file $hist_file" >/dev/stderr
        return 1
    end

    if test ! -e $hist_file
        touch $hist_file
    end

    if ! set dir (
        begin
            tac $hist_file
            fd \
                --type directory \
                --max-depth 5 \
                . $where
        end |
        perl -ne 'print unless $seen{$_}++'  |
        fzf --scheme=history --query=$query
    )
        echo "Couldn't determine new tmux session directory" >/dev/stderr
        return 1
    end

    if [ ! -e $dir ]
        echo "Directory $dir doesn't exist" >/dev/stderr
        return 1
    end

    if ! set rlpath (realpath $dir)/
        echo "Could not determine directory $dir's realpath" >/dev/stderr
        return 1
    end

    # If our path isn't in the hist file, we append it
    # Otherwise, we remove it and append it so that it becomes the last entry
    set new_hist_file (mktemp)
    begin
        grep --invert-match $rlpath $hist_file
        echo $rlpath
    end > $new_hist_file
    mv $new_hist_file $hist_file

    echo $rlpath
end
