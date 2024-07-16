function mdtopdf -a file
    set additional $argv[2..]
    set out (path change-extension pdf $file)
    echo "Rendering $file to $out"
    pandoc \
        --from markdown \
        --to pdf \
        --pdf-engine=xelatex \
        --output $out \
        $additional \
        $file
end
