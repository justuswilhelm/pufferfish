#!/bin/bash
# Prompt the user to pick an existing tmux session and connect to it
if ! session="$(tmux ls -F "#{session_name}" | fzf)"
then
    echo "No session specified. Exiting."
    exit 1
fi
exec tmux attach -t "$session"
