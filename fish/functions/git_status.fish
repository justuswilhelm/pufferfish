function git_status -d "Show git status"
    # Are we inside a git repo?
    if not command "$TIMEOUT_CMD" 0.1 git rev-parse --is-inside-work-tree 1>/dev/null 2>&1
        return
    end

    # Unstaged changes
    if not command "$TIMEOUT_CMD" 0.1 git diff --quiet
        set_color red
        echo -n "!"
        set_color normal
    end

    # Staged changes
    if not command "$TIMEOUT_CMD" 0.1 git diff --quiet --cached
        set_color yellow
        echo -n "*"
        set_color normal
    end

    # New files
    begin
        set -l IFS ""
        set -l files (command "$TIMEOUT_CMD" 0.1 git ls-files --others --exclude-standard)
        set -l count (count $files)
        if test $count -gt 0
            set_color green
            echo -n "+($count)"
        end
    end

    set_color blue
    echo -n ""(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')""
    set_color normal
end
