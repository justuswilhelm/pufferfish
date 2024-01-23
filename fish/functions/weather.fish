function weather -d "Echo weather forecast from wttr.in"
    while true
        clear
        curl --tlsv1.2 "https://wttr.in/$argv[1]"
        sleep 60
    end
end
