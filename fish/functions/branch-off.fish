function branch-off
    argparse 'p/parent=' 'r/remote=' no-remote -- $argv
    or return

    if set -q _flag_parent
        set parent "$_flag_parent"
        echo "Branching off $parent"
        if set -q _flag_remote
            set remote "$_flag_remote"
            echo "Using remote $remote"
        else
            set remote origin
            echo "Assuming remote is $remote"
        end

        if ! git fetch "$origin"
            echo "Could not fetch from $origin"
            return 1
        end
    else
        echo "Branching off "(git branch --show-current)
    end


    set user justus

    set date (date -I)

    if test -n "$argv[1]"
        set branchname "$argv[1]"
    else if read -P "Enter new branch name: " branchname
        echo "Using $branchname as new branch name"
    else
        echo "Must enter branch name"
        return 1
    end

    if set -q parent
        git checkout -b "$user/$date-$branchname" "$origin/$parent"
    else
        git checkout -b "$user/$date-$branchname"
    end; or return
end
