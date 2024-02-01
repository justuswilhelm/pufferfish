#!/usr/bin/env fish
# Indent all fish files in the fish folder
for file in */**.fish
  echo $file
  fish_indent < $file > temp.fish
  mv temp.fish $file
end
