#!/bin/bash
# https://apple.stackexchange.com/a/406097
set -e
/run/current-system/sw/bin/borgmatic create prune \
  --verbosity 1 \
  --log-file-verbosity 1 \
  --log-file "$HOME/Library/Logs/borgmatic/borgmatic.$(date -Iseconds).log" \
  2> >(/run/current-system/sw/bin/ts -m '[%Y-%m-%d %H:%M:%S] -' 1>&2) \
  1> >(/run/current-system/sw/bin/ts -m '[%Y-%m-%d %H:%M:%S] -')
