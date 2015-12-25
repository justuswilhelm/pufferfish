function cd
  builtin cd $argv
  if not tty -s
    return 0
  else if [ -e env/bin/activate ]
    s_env
  end
  return 0
end
