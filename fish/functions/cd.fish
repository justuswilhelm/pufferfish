function cd
  builtin cd $argv
  if not tty -s
    return 0
  else if [ -e env/bin/activate.fish ]
    source env/bin/activate.fish
  end
  return 0
end
