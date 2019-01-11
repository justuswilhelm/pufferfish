function git_status -d "Show git status"
    if timelimit -t 0.1 git rev-parse --is-inside-work-tree 1>/dev/null 2>&1
        if not timelimit -t 0.1 git diff --quiet
            set_color red
            echo -n "!"
            set_color normal
        end
        if not timelimit -t 0.1 git diff --quiet --cached
            set_color yellow
            echo -n "¡"
            set_color normal
        end
        begin
            set -l IFS ""
            set -l files (timelimit -t 0.1 git ls-files --others --exclude-standard)
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
end

