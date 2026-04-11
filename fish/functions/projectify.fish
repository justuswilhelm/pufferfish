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

    tmux new-session -c "$projectify_path" -d -s $session -n django
    tmux send-keys -t "$session:django" "uv run nvim" C-m

    tmux split-window -c "$projectify_path" -h -t "$session:django"
    tmux send-keys -t "$session:django" "git status" C-m

    # Serve backend django server
    tmux new-window -c "$projectify_path" -t $session -n django-serve
    tmux send-keys -t "$session:django-serve" "uv run honcho start" C-m

    # Open root folder
    tmux new-window -c "$projectify_path" -t $session -n shell
    tmux send-keys -t "$session:shell" "git status" C-m

    # Go to first window
    tmux select-window -t "$session:django"

    # Attach
    tsa $session
end
