function webcheck
  set -l PATHS apple-touch-icon.png browserconfig.xml crossdomain.xml favicon.ico robots.txt sitemap.xml tile-wide.png tile.png humans.txt
  if [ -z $argv[1] ]
    echo "Specify a host name to check"
    return 1
  end
  for path in $PATHS
    echo -ne "http://$argv[1]/$path "
  end | \
  xargs -P16 -n1 curl -fIL -so /dev/null -w "%{url_effective}: %{http_code}\n"
  return $status
end
