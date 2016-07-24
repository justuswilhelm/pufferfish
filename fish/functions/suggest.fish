function suggest
    history | cut -f1,2 -d' ' | uniq -c | sort -r | head -n10
end
