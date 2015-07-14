# Better git init
function gi
  git init
  set files README.md CHANGELOG.md LICENSE CONTRIBUTING.md
  touch $files
  git add $files
  git commit -m "ADD: Initial commit"
end
