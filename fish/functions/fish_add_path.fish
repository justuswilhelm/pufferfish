function fish_add_path --description "Add paths to the PATH"
    if contains $argv $PATH
        return
    end
    set PATH $argv $PATH
end
