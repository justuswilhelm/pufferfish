function mkx -d "Create an executable at a path" -a dest
    if [ -e $dest ]
        echo "$(realpath "$dest") already exists, skipping initialization"
    else
        echo "#!/usr/bin/env sh
# Maybe set -e, -o pipefail or -u
echo Hello World
" > $dest
    end
    chmod -v u+x $dest
    ls -lh $dest
end
