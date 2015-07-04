function git_status
  if git rev-parse --is-inside-work-tree 1>/dev/null 2>&1
    if not git diff --quiet
      set_color red
      echo -n "✘ "
      set_color normal
    end
    if not git diff --quiet --cached
      set_color yellow
      echo -n "✷ "
      set_color normal
      end
    set_color blue
    echo -n ""(git name-rev --name-only --no-undefined --always HEAD) ""
    set_color normal
  end
end

function fish_prompt
  set_color yellow
  echo -n "$PWD "
  set_color normal
  git_status
  echo -n "\$ "
end
