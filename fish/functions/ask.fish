function ask
    if [ -z "$KAGI_API_TOKEN" ]
        echo "You need to set the environment variable KAGI_API_TOKEN"
        echo "Consult "
        echo "https://help.kagi.com/kagi/api/intro/auth.html"
        echo "for how to retrieve the correct token"
        return 1
    end

    if [ -z $1 ]
        read -P "Enter a query: " query || return
    else
        set query $1
        echo "Asking '$query'"
    end

    set query_data (jq --compact-output --arg query $query --null-input '{query: $query}') || return

    echo "Query data:" $query_data

    curl \
        -H "Authorization: Bot $KAGI_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data $query_data \
        https://kagi.com/api/v0/fastgpt |
        jq "."
end
