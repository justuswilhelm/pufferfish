function pbpaste
    if is_darwin
        /usr/bin/env pbpaste $argv
    else
        /usr/bin/env xclip -sel clipboard -o
    end
end
