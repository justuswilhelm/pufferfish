function branch-off -d "Branch off in git"
    argparse 'p/parent=' 'r/remote=' no-remote -- $argv
    or return

    if set -q _flag_remote
        set remote "$_flag_remote"
        echo "Using remote $remote"
    else if set -q _flag_no_remote
        echo "Assuming parent is a local branch"
    else
        set remote origin
        echo "Assuming remote is $remote"
    end

    if set -q _flag_parent
        set parent "$_flag_parent"

        if set -q remote
            if ! git fetch $remote
                echo "Could not fetch from $remote"
                return 1
            end
            set upstream "$remote/$parent"
        else
            set upstream $parent
        end
    else
        set upstream (git branch --show-current)
    end

    echo "Branching off $upstream"

    if set -q argv[1]
        set branchname $argv[1]
        echo "Using branchname $branchname"
    else if read -P "Enter new branch name: " branchname
        echo "Using $branchname as new branch name"
    else
        echo "Must enter branch name"
        return 1
    end

    set user justus
    set date (date -I)
    set new_branch "$user/$date-$branchname"

    echo "New branch will be $new_branch"

    git checkout -b $new_branch $upstream || return

    if set -q remote
        echo "Ensuring we are up to date with $remote"
        if ! git fetch $remote
            echo "
Couldn't fet git remote $remote, leaving new branch checked out, but you might
have to rebase against $remote/main manually."
            return 1
        end
        if ! git rebase "$remote/main"
            echo "
Couldn't rebase against $remote/main. Please check manually and try rebasing
again."
            return 1
        end
    end
end
