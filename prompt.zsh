#!/bin/bash
setopt prompt_subst
# shellcheck disable=SC2154
function git_status() {
  if git rev-parse --is-inside-work-tree 1>/dev/null 2>&1
  then
    git diff --quiet || echo -ne "%{$fg[red]%}✘%{$reset_color%} "
    git diff --quiet --cached || echo -ne "%{$fg[yellow]%}✷%{$reset_color%} "
    echo -n "%{$fg[blue]%}$(git name-rev --name-only --no-undefined --always HEAD)%{$reset_color%} "
  fi
}

# shellcheck disable=SC2034
{
  PROMPT="%{$fg[yellow]%}(%2~)%{$reset_color%} \$(git_status)%# "
  RPROMPT="%w%t"
}
