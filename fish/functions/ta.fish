function ta -d "Prompt the user to pick an existing tmux session and connect to it"
    if ! set sessions (tmux ls -F '#{session_name}')
        echo "Could not get sessions"
        return 1
    end
    if ! set session (printf '%s\n' $sessions | fzf)
        echo "No session specified."
        return 1
    end
    tsa $session || begin
        echo "Couldn't attach to tmux sessions"
        return 1
    end
end
