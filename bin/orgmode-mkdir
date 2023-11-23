#!/bin/bash
if ! parent="$(fd --type d | fzf)"
then
    echo "Must give parent"
    exit 1
fi
echo "Existing folders are:"

fd --type d . "$parent"

if ! read -p "new dir $parent" new_dir
then
    echo "Must give directory name"
    exit 1
fi

mkdir -v "$parent$new_dir"
