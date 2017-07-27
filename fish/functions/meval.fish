function meval
    set -l command "echo \$($argv[1])"
    set -l makefile "all:\n\t$command\n.PHONY: all\n"
    make -f (printf "$makefile" | psub)
end
