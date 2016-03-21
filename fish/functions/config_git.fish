function config_git
  git config --global push.default simple
  git config --global commit.template $DOTFILES/git/gitmessage
  git config --global core.editor (which nvim)
  git config --global core.excludesfile $DOTFILES/git/gitignore

  if not grep $HOME/.gitconfig -e 'email'
    echo "Enter your Git email address"
    read -l email
    git config --global user.email $email
  end
  if not grep $HOME/.gitconfig -e 'name'
    echo "Enter your Git name"
    read -l name
    git config --global user.name $name
  end
end

