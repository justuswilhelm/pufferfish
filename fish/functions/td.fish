function td -d "Create a new tmux session in a given directory"
    set hist_file $XDG_STATE_HOME/pufferfish/td.hist
    if ! mkdir -vp (dirname $hist_file)
        echo "Couldn't make directory for hist_file $hist_file"
        return 1
    end

    if ! set dir (begin tac $hist_file; fd -t d -d 4; end | fzf --scheme=history)
        echo "Couldn't determine new tmux session directory"
        return 1
    end

    if ! set rlpath (realpath $dir)
        echo "Could not determine directory $dir's realpath"
        return 1
    end

    if ! grep $rlpath $hist_file
        echo  >> $hist_file
    end

    if ! set session_name (basename $dir)
        echo "Couldn't determine new tmux session name"
        return 1
    end
    set session_name (string replace . _ $session_name)
    echo "Session name is" $session_name

    if tmux has-session -t $session_name
        echo "Session already created, attaching..."
        if ! tsa $session_name
            echo "Couldn't attach"
            return 1
        end
    end

    if ! tmux new-session -d -c $dir -s $session_name
        echo "Couldn't create new tmux session $session_name in directory $dir"
        return 1
    end
    if ! tsa $session_name
        echo "Couldn't tsa to session $session_name"
    end
end
