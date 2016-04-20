function weather
    while true
        clear
        curl "http://wttr.in/$argv[1]"
        sleep 60
    end
end
