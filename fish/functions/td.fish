function td -d "Create a new tmux session in a given directory"
    set hist_file $XDG_STATE_HOME/pufferfish/td.hist
    if ! mkdir -vp (dirname $hist_file)
        echo "Couldn't make directory for hist_file $hist_file"
        return 1
    end
    if ! set dir (fd -t d | fzf --scheme=history --history=$hist_file)
        echo "Couldn't determine new tmux session directory"
        return 1
    end
    if ! set session_name (basename $dir)
        echo "Couldn't determine new tmux session name"
        return 1
    end
    if ! tmux new-session -c $dir -s $session_name
        echo "Couldn't create new tmux session $session_name in directory $dir"
        return 1
    end
end
