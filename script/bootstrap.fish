#!/usr/bin/env fish
set DOTFILES $HOME/.dotfiles

function nvim_config
  # Fix wait for plugged to allow synchronous installation.
  # See https://github.com/junegunn/vim-plug/issues/104
  nvim +PlugInstall +qall
end

function symlinks
  mkdir -p "$HOME/.config/"
  ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
  ln -sf "$DOTFILES/fish" "$HOME/.config/fish"
  ln -sf "$DOTFILES/misc/latexmkrc" "$HOME/.latexmkrc"
  ln -sf "$DOTFILES/brewfile/Brewfile" "$HOME/.brewfile"
  # XXX fix this bug
  rm $DOTFILES/fish/fish
end

function chsh
  set FISH_PATH (which fish)
  if [ $SHELL != $FISH_PATH ]
    chsh -s $FISH_PATH
  end
end

function git_config
  git config --global push.default simple
  git config --global commit.template $DOTFILES/git/gitmessage
  git config --global core.editor (which nvim)
  git config --global core.excludesfile $DOTFILES/git/gitignore
  git submodule init
  git submodule update --init
end

function python_config
  pip3 install -r $DOTFILES/python/requirements.txt
end

function check_dependencies
  if not type nvim > /dev/null ^&1
    echo "Please install nvim"
    exit 1
  end

  if not type pip3 > /dev/null ^&1
    echo "Install a global python3-pip"
    exit 1
  end
end

function brew_config
  if not type brew > /dev/null ^&1
    echo "No brew installed"
    return 0
  end
  brew file install --preupdate
  brew file clean -C
  brew upgrade
  brew cleanup
  brew cask cleanup
end

nvim_config
chsh
symlinks
git_config
python_config
brew_config
