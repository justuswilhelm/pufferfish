function pvdd
    pv "$argv[1]" | sudo dd "of=$argv[2]" bs=1m
end
