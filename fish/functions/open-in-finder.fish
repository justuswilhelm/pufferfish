function open-in-finder
    set hist_file $XDG_STATE_HOME/pufferfish/open-in-finder.hist

    if ! mkdir -vp (dirname $hist_file)
        echo "Couldn't make directory for hist_file $hist_file"
        return 1
    end

    if test ! -e $hist_file
        touch $hist_file
    end

    if ! set dir (
        begin
            cat $hist_file
            fd \
                --type directory \
                --max-depth 5 \
                . $HOME
        end | fzf --scheme=history
    )
        echo "Couldn't determine directory to open"
        return 1
    end

    if ! set rlpath (realpath $dir)/
        echo "Could not determine directory $dir's realpath"
        return 1
    end

    if ! grep $rlpath $hist_file
        echo $rlpath >>$hist_file
    end

    open -a Finder $rlpath || return
end
