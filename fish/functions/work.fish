# SPDX-FileCopyrightText: 2026 Justus Perlwitz
# SPDX-License-Identifier: GPL-3.0-or-later

function work -d "(git) Create a '\$name' worktree and cd there" -a name
    if [ -z "$name" ]
        echo "usage: work <name>"
        return 1
    end
    set dest $PWD/../$name

    if ! git worktree add $dest
        echo "Couldn't create worktree with name $name at destination $dest"
        return 1
    else
        echo "Created worktree with name $name at destination $dest"
    end

    if ! cd $destination
        echo "Couldn't change directory into destination $dest"
    end
end
