#!/bin/bash
# https://apple.stackexchange.com/a/406097
set -e
/opt/local/bin/borgmatic create prune -v2 \
  2> >(/opt/local/bin/ts -m '[%Y-%m-%d %H:%M:%S] -' 1>&2) \
  1> >(/opt/local/bin/ts -m '[%Y-%m-%d %H:%M:%S] -')
