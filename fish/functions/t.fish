function t -d "Create a new tmux session with the given name" -a name
    if [ -n "$name" ]
        set session $name
    else if ! read -P "New tmux session name: " session
        echo "No session name specified. Exiting."
        return 1
    end
    tmux new-session -s $session
end
