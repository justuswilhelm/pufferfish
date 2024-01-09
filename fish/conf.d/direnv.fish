if command -q direnv
    direnv hook fish | source
else
    echo "Direnv not present"
end
