function pvdd -d "Pipe file into dd using pipeviewer"
    if is_darwin
        set -l DD_FLAG bs=4m
    else
        set -l DD_FLAG bs=4M
    end
    pv "$argv[1]" | sudo dd "of=$argv[2]" $DD_FLAG
end
