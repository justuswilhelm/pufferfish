# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function projectify --description "Launch a Projectify tmux session"
    # This is a relatively complete example of how to create a complex session in
    # tmux using nothing but tmux commands
    set session projectify
    set projectify_path "$HOME/projects/projectify/monorepo"

    # Attach if already created
    if tmux has-session -t $session
        tsa $session
        return
    end
    # Editor for backend
    tmux new-window -c "$projectify_path/backend" -t $session -n backend
    tmux send-keys -t "$session:backend" "poetry run nvim" C-m

    tmux split-window -c "$projectify_path/backend" -h -t "$session:backend"
    tmux send-keys -t "$session:backend" "git status" C-m

    # Serve backend django server
    tmux new-window -c "$projectify_path/backend" -t $session -n backend-serve
    tmux send-keys -t "$session:backend-serve" "poetry run ./manage.py runserver" C-m
    tmux split-window -c "$projectify_path/backend" -v -t "$session:backend-serve"
    tmux send-keys -t "$session:backend-serve" "poetry run ./manage.py tailwind start" C-m

    # Open root folder
    tmux new-window -c "$projectify_path" -t $session -n shell
    tmux send-keys -t "$session:shell" "git status" C-m

    # Go to first window
    tmux select-window -t "$session:backend"

    # Attach
    tsa $session
end
