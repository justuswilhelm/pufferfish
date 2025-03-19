function push_git --description "Push to a remote, create repo if needed" -a remote
    if test -z "$remote"
        echo "Must specify remote"
        return 1
    end

    set dir '~/'(realpath --relative-to=$HOME $PWD)
    echo "Using path '$dir' for remote repository directory"

    set remote_name (string replace --regex '.local$' "" $remote)
    echo "Setting remote name for remote '$remote' to '$remote_name'"

    if git remote get-url $remote_name > /dev/null
        echo "Remote with name '$remote_name' already exists"
        return 1
    end

    set remote_url "ssh://$USER@$remote/$dir"

    echo "Using address '$remote_url' for remote '$remote'"

    echo "SSH'ing into remote '$remote' to create repository at path '$dir'"
    ssh $remote "git init $dir" || return

    git remote add $remote_name $remote_url || return

    # TODO detect if annex, otherwise skip this
    git annex sync || return
end
