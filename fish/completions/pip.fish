complete -c pip -s h -l help -d 'Show help'
complete -c pip -l isolated -d 'Run pip in an isolated mode, ignoring environment variables and user configuration.'
complete -c pip -s v -l verbose -d 'Give more output. Option is additive, and can be used up to 3 times.'
complete -c pip -s V -l version -d 'Show version and exit.'
complete -c pip -s q -l quiet -d 'Give less output.'
complete -c pip -l log -d 'Path to a verbose appending log.' # <path>
complete -c pip -l proxy -d 'Specify a proxy in the form [user:passwd@]proxy.server:port.'  # <proxy>
complete -c pip -l retries -d 'Maximum number of retries each connection should attempt (default 5 times).' #<retries> 
complete -c pip -l timeout -d 'Set the socket timeout (default 15 seconds).' # <sec>
complete -c pip -l exists-action -d 'Default action when a path already exists: (s)witch, (i)gnore, (w)ipe, (b)ackup.' # <action>
complete -c pip -l trusted-host  -d 'Mark this host as trusted, even though it does not have valid or any HTTPS.' # <hostname>
complete -c pip -l cert -d 'Path to alternate CA bundle.' # <path>
complete -c pip -l client-cert -d 'Path to SSL client certificate, a single file containing the private key and the certificate in PEM format.' # <path>
complete -c pip -l cache-dir -d 'Store the cache data in <dir>.' # <dir>
complete -c pip -l no-cache-dir -d 'Disable the cache.'
complete -c pip -l disable-pip-version-check -d "Don't periodically check PyPI to determine whether a new version of pip is available for download.  Implied with --no-index."
