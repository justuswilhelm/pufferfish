function open-in-finder
    set dir (fd --type directory | fzf) || return
    open -a Finder $dir || return
end
