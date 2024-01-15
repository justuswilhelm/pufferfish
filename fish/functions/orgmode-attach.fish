function orgmode-attach
    # Add orgmode paths here
    set ORGMODE_PATHS ""

    if ! set path (echo "$ORGMODE_PATHS" | fzf)
        echo "No path was specified"
        return 1
    end

    set session "orgmode-"(basename "$path" | tr "A-Z " "a-z-")

    echo "Assuming session name $session"

    if tmux has-session -t "$session"
        echo "Attaching to session"
        tsa "$session:0"; or return 1
        return
    else
        echo "Session does not exist yet"
    end

    # -d prevents attaching
    if tmux new-session -c "$path" -d -s "$session" -n "nvim"
        echo "Created session"
    else
        echo "Couldn't create session"
        return 1
    end

    tmux send-keys -t "$session:0" "nvim" C-m || return 1

    tmux new-window -c "$path" -t "$session" -n "files" || return 1
    tmux send-keys -t "$session:1" "ls" C-m || return 1

    tsa "$session:0"
end
