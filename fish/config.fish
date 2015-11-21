source ~/.config/fish/alias.fish
# Homebrew
set PATH $PATH /usr/local/bin:/usr/local/sbin

# Heroku toolbelt
set PATH $PATH /usr/local/heroku/bin

# MacTex
set PATH $PATH /usr/local/texlive/2014basic/bin/x86_64-darwin/

# Local Bin
set PATH $PATH ~/bin

if [ -f /usr/local/share/autojump/autojump.fish ]
  source /usr/local/share/autojump/autojump.fish
end

if isatty
  cd .
end
