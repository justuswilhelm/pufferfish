function mcd --description "Make a dir, cd there" --argument dest
    mkdir -v -p $dest || return
    cd $dest || return
end
