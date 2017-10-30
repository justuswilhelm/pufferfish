function moon -d "Show moon"
    while true
        clear
        curl http://wttr.in/moon
        sleep 3600
    end
end
