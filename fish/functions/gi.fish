# Better git init
function gi
  set files ("README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md")
  touch $files
  git add $files
end
