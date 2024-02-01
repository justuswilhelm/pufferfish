function t -d "Create a new tmux session with the given name"
    if ! read -P "New tmux session name: " session
        echo "No session name specified. Exiting."
        return 1
    end
    tmux new-session -s $session
end
