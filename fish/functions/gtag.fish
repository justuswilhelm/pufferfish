function gtag
  set changelog_version (awk '$1 == "##" {print $2;exit}' < CHANGELOG.md | egrep -e '(\d+\.\d+\.\d+)' -o)
  git tag $changelog_version
end
