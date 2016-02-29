function init
    if test ! -d $argv[1]
        mkdir $argv[1]
    end
    touch $argv[1]/__init__.py
end
