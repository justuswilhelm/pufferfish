source ~/.config/fish/alias.fish
# Homebrew
set PATH $PATH /usr/local/bin:/usr/local/sbin

# Heroku toolbelt
set PATH $PATH /usr/local/heroku/bin

if [ -f /usr/local/share/autojump/autojump.fish ]
  source /usr/local/share/autojump/autojump.fish
end

if isatty
  cd .
end
