#!/bin/bash
if test -z "$KAGI_API_TOKEN"
then
    echo "You need to set the environment variable KAGI_API_TOKEN"
    echo "Consult "
    echo "https://help.kagi.com/kagi/api/intro/auth.html"
    echo "for how to retrieve the correct token"
    exit 1
fi

if test -z "$1"
then
    read -p "Enter a query: " query
else
    query="$1"
    echo "Asking '$query'"
fi

query=$(jq --arg query "$query" --null-input '{query: $query}')

curl \
  -H "Authorization: Bot $KAGI_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data "$query" \
  https://kagi.com/api/v0/fastgpt |
  jq "."
