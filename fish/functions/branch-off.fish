function branch-off
    argparse 'p/parent=' 'r/remote=' no-remote -- $argv
    or return

    if set -q _flag_parent
        set parent "$_flag_parent"
        if set -q _flag_remote
            set remote "$_flag_remote"
            echo "Using remote $remote"
        else if set -q _flag_no_remote
            echo "Assuming parent is a local branch"
        else
            set remote origin
            echo "Assuming remote is $remote"
        end

        if set -q remote
            if ! git fetch "$remote"
                echo "Could not fetch from $remote"
                return 1
            end
            set upstream "$remote/$parent"
        else
            set upstream "$parent"
        end

        echo "Branching off $upstream"
    else
        set upstream (git branch --show-current)
        echo "Branching off current branch $upstream"
    end

    if test -n "$argv[1]"
        set branchname "$argv[1]"
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
    git checkout -b "$new_branch" "$upstream"
end
