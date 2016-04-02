function config_python
    if set -q VIRTUAL_ENV
        echo "Storing \$VIRTUAL_ENV"
        set -l _VIRTUAL_ENV $VIRTUAL_ENV
        set -e VIRTUAL_ENV
    end
    if contains $argv "clean"
	pip2 freeze | grep -v -E 'vboxapi|git' | xargs pip2 uninstall -y
	pip3 freeze | grep -v -E 'vboxapi|git' | xargs pip3 uninstall -y
    end
    pip2 install -r $DOTFILES/python/requirements2.txt
    pip3 install -r $DOTFILES/python/requirements.txt
    if set -q _VIRTUAL_ENV
        echo "Restoring \$VIRTUAL_ENV"
        set -l VIRTUAL_ENV $_VIRTUAL_ENV
    end
end

