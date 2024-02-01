#!/bin/bash
set -e
dest="$1"
if [ -a "$dest" ]
then
    echo "$(realpath "$dest") already exists"
    exit 1
fi
printf "#!/bin/bash\necho Hello World" > "$dest"
chmod -v +x "$dest"
