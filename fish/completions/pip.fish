function __fish_pip_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 ]
    return 0
  end
  return 1
end

function __fish_pip_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

complete -f -c pip -s h -l help \
  -d 'Show help'
complete -f -c pip -l isolated \
  -d 'Run pip in an isolated mode, ignoring environment variables and user configuration.'
complete -f -c pip -s v -l verbose \
  -d 'Give more output. Option is additive, and can be used up to 3 times.'
complete -f -c pip -s V -l version \
  -d 'Show version and exit.'
complete -f -c pip -s q -l quiet \
  -d 'Give less output.'
complete -f -c pip -l log \
  -d 'Path to a verbose appending log.' # <path>
complete -f -c pip -l proxy \
  -d 'Specify a proxy in the form [user:passwd@]proxy.server:port.' # <proxy>
complete -f -c pip -l retries \
  -d 'Maximum number of retries each connection should attempt (default 5 times).' #<retries> 
complete -f -c pip -l timeout \
  -d 'Set the socket timeout (default 15 seconds).' # <sec>
complete -f -c pip -l exists-action \
  -d 'Default action when a path already exists: (s)witch, (i)gnore, (w)ipe, (b)ackup.' # <action>
complete -f -c pip -l trusted-host \
  -d 'Mark this host as trusted, even though it does not have valid or any HTTPS.' # <hostname>
complete -f -c pip -l cert \
  -d 'Path to alternate CA bundle.' # <path>
complete -f -c pip -l client-cert \
  -d 'Path to SSL client certificate, a single file containing the private key and the certificate in PEM format.' # <path>
complete -f -c pip -l cache-dir \
  -d 'Store the cache data in <dir>.' # <dir>
complete -f -c pip -l no-cache-dir \
  -d 'Disable the cache.'
complete -f -c pip -l disable-pip-version-check \
  -d "Don't periodically check PyPI to determine whether a new version of pip is available for download.  Implied with --no-index."

# install
complete -f -c pip -n '__fish_pip_needs_command' -a install \
  -d "Don't periodically check PyPI to determine whether a new version of pip is available for download.  Implied with --no-index."

# download
complete -f -c pip -n '__fish_pip_needs_command' -a download \
  -d "Download packages."

# uninstall
complete -f -c pip -n '__fish_pip_needs_command' -a uninstall \
  -d "Uninstall packages."

# freeze
complete -f -c pip -n '__fish_pip_needs_command' -a freeze \
  -d "Output installed packages in requirements format."

# list
complete -f -c pip -n '__fish_pip_needs_command' -a list \
  -d "List installed packages."

# show
complete -f -c pip -n '__fish_pip_needs_command' -a show \
  -d "Show information about installed packages."

# search
complete -f -c pip -n '__fish_pip_needs_command' -a search \
  -d "Search PyPI for packages."

# wheel
complete -f -c pip -n '__fish_pip_needs_command' -a wheel \
  -d "Build wheels from your requirements."

# hash
complete -f -c pip -n '__fish_pip_needs_command' -a hash \
  -d "Compute hashes of package archives."

# help
complete -f -c pip -n '__fish_pip_needs_command' -a help \
  -d "Show help for commands."

complete -f -c pip -n '__fish_pip_using_command help' \
  -a 'install download uninstall freeze list show search wheel hash help'
