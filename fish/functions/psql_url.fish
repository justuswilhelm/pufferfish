function psql_url
    if test (count $argv) -ne 1
        return 1
    end
    set url "postgres://$USER@localhost/$argv[1]"
    if not psql -c "" $url
        echo "ERROR: This database has not been created"
        return 1
    end
    echo $url
end
