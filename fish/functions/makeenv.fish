function makeenv -d "Create python 3 environment and install requirements"
    set ENV_DIR env
    set REQUIREMENTS "requirements.txt"
    if [ -d "$ENV_DIR" ]
        echo "Path $ENV_DIR already exists, aborting."
        return 1
    else
        python3 -m venv $ENV_DIR
        source "$ENV_DIR/bin/activate.fish"
        if [ -e "$REQUIREMENTS" ]
            pip install -r "$REQUIREMENTS"
        end
    end
end
