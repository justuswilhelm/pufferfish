function mkx -d "Create an executable at path" -a dest
    if [ -e $dest ]
        echo "$(realpath "$dest") already exists"
        return 1
    end
    echo "#!/usr/bin/env sh
# Maybe set -e, -o pipefail or -u
echo Hello World
" >$dest
    chmod -v u+x $dest
    ls -lh $dest
end
