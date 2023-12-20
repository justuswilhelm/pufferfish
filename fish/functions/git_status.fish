# Very helpful resource:
# https://stackoverflow.com/questions/2657935/checking-for-a-dirty-index-or-untracked-files-with-git/2659808#2659808
function git_status -d "Show git status"
    # Are we inside a git repo?
    command "$TIMEOUT_CMD" 0.1 git rev-parse --is-inside-work-tree &>/dev/null
    switch "$status"
        case 0
            # Happy path
        case 128
            # We are not inside git repository
            # 128 was derived by running git rev-parse --inside-work-tree
            # inside non-git dir tree
            return
        case 124
            # Timed out
            return
        case '*'
            echo "Some other error occured"
            return
    end

    # Unstaged changes
    command "$TIMEOUT_CMD" 0.1 git diff-files --quiet --exit-code
    switch "$status"
        case 0
            # Happy path
        case 1
            set_color red
            printf "!"
        case 124
            # Timed out
            return
        case '*'
            echo "Error when checking for unstaged changes"
            return
    end

    # Staged changes
    command "$TIMEOUT_CMD" 0.1 git diff-index --quiet --cached HEAD --
    switch "$status"
        case 0
            # Happy path
        case 1
            set_color yellow
            printf "*"
        case 124
            # Timed out
            return
        case '*'
            echo "Error when checking for staged changes"
            return
    end

    # Untracked files
    set files (
        command "$TIMEOUT_CMD" 0.1 git ls-files -z --others --exclude-standard
    )
    switch "$status"
        case 0
            set count (printf "$files" | string split0 | count)
            if [ "$count" -gt 0 ]
                set_color green
                printf "+(%d)" "$count"
            end
        case 124
            # Timed out
            return
        case "*"
            echo "Error when counting untracked files"
            return
    end

    set_color blue
    if ! git branch --show-current | tr -d '\n'
        echo "Error when getting current branch"
        return
    end
    set_color normal
end
