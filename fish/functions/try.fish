function try
    echo "Trying to run $argv"
    while not eval $argv
        echo "Fail, sleeping 1 second"
        sleep 1
    end
end
