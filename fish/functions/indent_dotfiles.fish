function indent_dotfiles -d "Indent all fish files in the fish folder"
    for file in (fd -e fish . $DOTFILES/fish)
        echo "Fixing up $file"
        fish_indent -w $file
    end
end
