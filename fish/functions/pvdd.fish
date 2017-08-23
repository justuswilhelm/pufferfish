function pvdd
	if is_darwin
        set -l block 1m
    else
        set -l block 1M
    end
	pv "$argv[1]" | sudo dd "of=$argv[2]" bs=1M
end
