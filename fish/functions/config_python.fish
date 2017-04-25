function config_python
    if set -q VIRTUAL_ENV
        echo "Storing \$VIRTUAL_ENV"

        set -l _VIRTUAL_ENV $VIRTUAL_ENV
        set -e VIRTUAL_ENV
    end
    set -l IGNORE 'pip|setuptools|pkg_resources|six'
    if contains $argv "clean"
        pip2 list | cut -f1 -d' ' | grep -v -E "$IGNORE" | xargs pip2 uninstall -y
        pip3 list | cut -f1 -d' ' | grep -v -E "$IGNORE" | xargs pip3 uninstall -y
    end
    pip2 install -r $DOTFILES/python/requirements2.txt --upgrade
    pip3 install -r $DOTFILES/python/requirements.txt --upgrade
    if set -q _VIRTUAL_ENV
        echo "Restoring \$VIRTUAL_ENV"
        set -l VIRTUAL_ENV $_VIRTUAL_ENV
    end
end

