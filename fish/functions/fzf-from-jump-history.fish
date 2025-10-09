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
        # SPDX-SnippetBegin
        # SPDX-License-Identifier: CC-BY-SA-4.0
        # SPDX-SnippetCopyrightText: Digital Trauma
        # sort -uk2 | sort -n | cut -f2- |
        # SPDX-SnippetEnd
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

    if ! grep $rlpath $hist_file >/dev/null
        echo $rlpath >>$hist_file
    end

    echo $rlpath
end
