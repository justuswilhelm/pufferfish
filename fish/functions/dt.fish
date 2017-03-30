function dt
    mkdir -vp (dirname "$argv[1]")
    touch "$argv[1]"
end
