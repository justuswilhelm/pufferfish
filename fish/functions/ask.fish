function ask
    if [ -z "$KAGI_API_TOKEN" ]
        echo "You need to set the environment variable KAGI_API_TOKEN"
        echo "Consult "
        echo "https://help.kagi.com/kagi/api/intro/auth.html"
        echo "for how to retrieve the correct token"
        exit 1
    end

    if [ -z $1 ]
        read -P "Enter a query: " query
    else
        set query $1
        echo "Asking '$query'"
    end

    set query (jq --arg query $query --null-input '{query: $query}')

    curl \
        -H "Authorization: Bot $KAGI_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data $query \
        https://kagi.com/api/v0/fastgpt |
    jq "."
end
