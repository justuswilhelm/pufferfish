function makeenv
    set ENV_DIR "env"
    set REQUIREMENTS "requirements.txt"
    if [ -d "$ENV_DIR" ]
        echo "Path $ENV_DIR already exists, aborting."
        return 1
    else
        pyvenv $ENV_DIR
        sed -i.bak '45,74d' "$ENV_DIR/bin/activate.fish"
        source "$ENV_DIR/bin/activate.fish"
        if [ -e "$REQUIREMENTS" ]
            pip install -r "$REQUIREMENTS"
        end
    end
end
