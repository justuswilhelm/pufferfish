function fish_add_path --description "Add paths to the PATH"
    if contains $argv $fish_user_paths
        return
    end
    set fish_user_paths $argv $fish_user_paths
end
