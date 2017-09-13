function random_mac
    set IF "en0"
    set MAC (openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    echo "New MAC: $MAC"
    sudo ifconfig "$IF" ether "$MAC"
end
