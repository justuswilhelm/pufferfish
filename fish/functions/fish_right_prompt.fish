function fish_right_prompt
  set last_status "$status"
  set_color green
  if math "$last_status > 0" >/dev/null
    set_color red
  end
  echo -n "[$last_status]"
  set_color blue
  date "+%H%M"
  set_color magenta
  date "+%h%d"
  set_color normal
end
