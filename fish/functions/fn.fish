function fn -d "Open nnn at folder chosen with fzf"
    set p (
        fd --type d \
            --strip-cwd-prefix \
            --hidden \
            --follow \
            --exclude .git |
        fzf)
    and nnn $p
end
