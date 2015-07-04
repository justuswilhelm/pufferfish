function fish_right_prompt
  set last_status "$status"
  if math "$last_status > 0" >/dev/null
    set_color red
  end
  echo -n "$last_status "
  set_color normal
  date "+%h %d"
end
