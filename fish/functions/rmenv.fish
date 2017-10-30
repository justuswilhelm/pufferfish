function rmenv -d "Remove Python 3 environment folder at env/"
    deactivate
    or echo "Deactivate not necessary"
    rm -rf env/
end
