function tsa --description "(tmux) Switch or Attach to a tmux session"
    set session "$argv[1]"
    if [ -z "$session" ]
        echo "Must specify session"
        return 1
    end
    if set -q TMUX
        echo "Already in tmux, switching to session $session"
        tmux switch-client -t "$session" || begin
            echo "Couldn't switch to session $session"
        end
    else
        echo "Attaching to $session"
        tmux attach-session -t "$session" || begin
            echo "Couldn't attach to session $session"
        end
    end
end
