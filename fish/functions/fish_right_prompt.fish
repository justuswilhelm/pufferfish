function fish_right_prompt
    set last_status "$status"
    if math "$last_status > 0" >/dev/null
        set_color red
    else
        set_color green
    end
    echo -n "$last_status"
    set_color blue
    date "+%H%M" | tr -d '\n'
    set_color magenta
    date "+%h%d" | tr -d '\n'
    set_color normal
end
