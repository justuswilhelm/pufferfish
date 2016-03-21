function config_python
  if set -q VIRTUAL_ENV
    echo "Storing \$VIRTUAL_ENV"
    set -l _VIRTUAL_ENV $VIRTUAL_ENV
    set -e VIRTUAL_ENV
  end
  pip3 install -r $DOTFILES/python/requirements.txt
  if set -q _VIRTUAL_ENV
    echo "Restoring \$VIRTUAL_ENV"
    set -l VIRTUAL_ENV $_VIRTUAL_ENV
  end
end

