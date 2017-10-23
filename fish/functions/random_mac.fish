function random_mac
    openssl rand -hex 6 | sed -E 's/(..)/\1:/g; s/.$//'
end
