function cd
  builtin cd $argv
  if [ -e env/bin/activate ]
    s_env
  end
  return 0
end
