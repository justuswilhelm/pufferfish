function weather -d "Echo weather forecast from wttr.in"
    while true
        clear
        curl "http://wttr.in/$argv[1]"
        sleep 60
    end
end
