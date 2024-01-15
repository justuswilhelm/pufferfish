#!/usr/bin/env sh
# Create a new tmux session with the given name
if ! read -p "New tmux session name: " session
then
    echo "No session name specified. Exiting."
fi
exec tmux new-session -s "$session"
