# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function ta -d "(tmux) Prompt the user to pick an existing tmux session and attach to it" -a where
    if [ -n "$where" ]
        set session $where
    else
        if ! set sessions (tmux ls -F '#{session_name}')
            echo "Could not get sessions"
            return 1
        end
        if ! set session (printf '%s\n' $sessions | fzf)
            echo "No session specified."
            return 1
        end
    end
    tsa $session || begin
        echo "Couldn't attach to tmux sessions"
        return 1
    end
end
