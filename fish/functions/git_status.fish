function git_status
    if git rev-parse --is-inside-work-tree 1> /dev/null 2>& 1
        if not git diff --quiet
            set_color red
            echo -n "!"
            set_color normal
        end
        if not git diff --quiet --cached
            set_color yellow
            echo -n "¡"
            set_color normal
        end
        begin
            set -l IFS ""
            if test -n ""(git ls-files --others --exclude-standard)""
                set_color green
                echo -n "+"
            end
        end
        set_color blue
        echo -n ""(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')""
        set_color normal
    end
end

