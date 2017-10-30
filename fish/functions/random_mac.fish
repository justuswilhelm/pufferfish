function random_mac -d "Echo random MAC address"
    openssl rand -hex 6 | sed -E 's/(..)/\1:/g; s/.$//'
end
