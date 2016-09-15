function snippet
    set -l snippet_name $argv[1]
    if test (count $argv) -eq 3
        set -l target $argv[2]
    else
        set -l target $snippet_name
    end
    set -l snippet_file "$DOTFILES/snippets/$snippet_name"
    if not test -e "$snippet_file"
        echo "Snippet $snippet_name could not be found under $snippet_file"
        return 1
    end
    if test -d "$snippet_file"
        echo "INFO: Snippet $snippet_name is a folder. Performing recursive cp"
    end
    cp -r "$snippet_file" "$target"
end
