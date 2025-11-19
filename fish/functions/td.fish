# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

function td -d "(tmux) Create a new tmux session in a given directory" -a query
    if ! set dir (fzf-from-jump-history --query=$query)
        echo "fzf-from-jump-history failed" >/dev/stderr
        return 1
    end

    if ! set session_name (basename $dir)
        echo "Couldn't determine new tmux session name" >/dev/stderr
        return 1
    end
    set session_name (string replace . _ $session_name)
    echo "Session name is" $session_name >/dev/stderr

    if tmux has-session -t $session_name
        echo "Session already created, attaching..." >/dev/stderr
        if ! tsa $session_name
            echo "Couldn't attach" >/dev/stderr
            return 1
        end
    end

    if ! tmux new-session -d -c $dir -s $session_name
        echo "Couldn't create new tmux session $session_name in directory $dir" >/dev/stderr
        return 1
    end
    if ! tsa $session_name
        echo "Couldn't tsa to session $session_name" >/dev/stderr
    end
end
