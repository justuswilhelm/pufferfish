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

function __fish_pip_using_option
    set cmd (commandline -opc)
    if [ (count $cmd) -gt 1 ]
        if contains $argv[1] $cmd[-1]
            return 0
        end
    end
    return 1
end

function __fish_pip_freeze
    pip freeze -r
end

############
# Commands #
############

# download
complete -f -c pip -n '__fish_pip_needs_command' -a download -d 'Download packages.'
# TODO

# freeze
complete -f -c pip -n '__fish_pip_needs_command' -a freeze -d 'Output installed packages in requirements format.'
complete -f -c pip -n '__fish_pip_using_command freeze' -s r -l requirement -d 'Use the order in the given requirements file and its comments when generating output.' # <file>
complete -f -c pip -n '__fish_pip_using_command freeze' -s l -l local -d 'If in a virtualenv that has global access, do not output globally-installed packages.'
complete -f -c pip -n '__fish_pip_using_command freeze' -l user -d 'Only output packages installed in user-site.'

# hash
complete -f -c pip -n '__fish_pip_needs_command' -a hash -d "Compute hashes of package archives."
# TODO

# help
complete -f -c pip -n '__fish_pip_needs_command' -a help -d 'Show help for commands.'
complete -f -c pip -n '__fish_pip_using_command help' -a 'install download uninstall freeze list show search wheel hash help'

# install
complete -f -c pip -n '__fish_pip_needs_command' -a install -d 'Install packages.'
# TODO

# list
complete -f -c pip -n '__fish_pip_needs_command' -a list -d 'List installed packages.'
# TODO

# search
complete -f -c pip -n '__fish_pip_needs_command' -a search -d 'Search PyPI for packages.'
complete -f -c pip -n '__fish_pip_using_command search' -l index -d "Base URL of Python Package Index (default https://pypi.python.org/pypi)"

# show
complete -f -c pip -n '__fish_pip_needs_command' -a show -d 'Show information about installed packages.'
complete -f -c pip -n '__fish_pip_using_command show' -s f -l files -d 'Show the full list of installed files for each package.'
# TODO

# uninstall
complete -f -c pip -n '__fish_pip_needs_command' -a uninstall -d 'Uninstall packages.'
complete -f -c pip -n '__fish_pip_using_command uninstall' -a '(pip freeze)' -d 'Uninstall packages.'

# wheel
complete -f -c pip -n '__fish_pip_needs_command' -a wheel -d "Build wheels from your requirements."
complete -f -c pip -n '__fish_pip_using_command wheel' -s w, -l wheel-dir -d 'Build wheels into <dir>, where the default is the current working directory.' # <dir>
complete -f -c pip -n '__fish_pip_using_option -w --wheel-dir'
complete -f -c pip -n '__fish_pip_using_command wheel' -l no-use-wheel -d 'Do not Find and prefer wheel archives when searching indexes and find-links locations. DEPRECATED in favour of --no-binary.'
complete -f -c pip -n '__fish_pip_using_command wheel' -l no-binary -d 'Do not use binary packages. Can be supplied multiple times, and each time adds to the existing value. Accepts either :all: to disable all binary packages, :none: to empty the set, or one or more package names with commas between them.  Note that some packages are tricky to compile and may fail to install when this option is used on them.' # <format_control>
complete -f -c pip -n '__fish_pip_using_command wheel' -l only-binary -d 'Do not use source packages. Can be supplied multiple times, and each time adds to the existing value. Accepts either :all: to disable all source packages, :none: to empty the set, or one or more package names with commas between them.  Packages without binary distributions will fail to install when this option is used on them.' # <format_control>
complete -f -c pip -n '__fish_pip_using_command wheel' -l build-option -d 'Extra arguments to be supplied to \'setup.py bdist_wheel\'' # <options>
complete -f -c pip -n '__fish_pip_using_command wheel' -s c -l constraint -d 'Constrain versions using the given constraints file. This option can be used multiple times.' # <file> 
complete -f -c pip -n '__fish_pip_using_command wheel' -s e -l editable -d 'Install a project in editable mode (i.e. setuptools "develop mode") from a local project path or a VCS url.' # <path/url>
complete -f -c pip -n '__fish_pip_using_command wheel' -s r -l requirement -d 'Install from the given requirements file. This option can be used multiple times.' # <file>
complete -f -c pip -n '__fish_pip_using_command wheel' -l src -d 'Directory to check out editable projects into. The default in a virtualenv is "<venv path>/src". The default for global installs is "<current dir>/src".' # <dir> 
complete -f -c pip -n '__fish_pip_using_command wheel' -l no-deps -d 'Don\'t install package dependencies.'
complete -f -c pip -n '__fish_pip_using_command wheel' -s b -l build -d 'Directory to unpack packages into and build in' # <dir>
complete -f -c pip -n '__fish_pip_using_command wheel' -l global-option -d 'Extra global options to be supplied to the setup.py call before the \'bdist_wheel\' command.' # <options>
complete -f -c pip -n '__fish_pip_using_command wheel' -l pre -d 'Include pre-release and development versions. By default, pip only finds stable versions.'
complete -f -c pip -n '__fish_pip_using_command wheel' -l no-clean -d 'Don\'t clean up build directories.'
complete -f -c pip -n '__fish_pip_using_command wheel' -l require-hashes -d 'Require a hash to check each requirement against, for repeatable installs. This option is implied when any package in a requirements file has a --hash option.'
complete -f -c pip -n '__fish_pip_using_command wheel' -s i -l index-url -d 'Base URL of Python Package Index (default https://pypi.python.org/simple).' # <url>
complete -f -c pip -n '__fish_pip_using_command wheel' -l extra-index-url\
 -d 'Extra URLs of package indexes to use in addition to --index-url.' # <url>
complete -f -c pip -n '__fish_pip_using_command wheel' -l no-index -d 'Ignore package index (only looking at --find-links URLs instead).'
complete -f -c pip -n '__fish_pip_using_command wheel' -s f -l find-links -d 'If a url or path to an html file, then parse for links to archives. If a local path or file:// url that\'s a directory,then look for archives in the directory listing.' # <url>
complete -f -c pip -n '__fish_pip_using_command wheel' -l process-dependency-links -d 'Enable the processing of dependency links.'

############
# Switches #
############
complete -f -c pip -l cache-dir -d 'Store the cache data in <dir>.' # <dir>
complete -f -c pip -l cert -d 'Path to alternate CA bundle.' # <path>
complete -f -c pip -l client-cert -d 'Path to SSL client certificate, a single file containing the private key and the certificate in PEM format.' # <path>
complete -f -c pip -l disable-pip-version-check -d 'Don\'t periodically check PyPI to determine whether a new version of pip is available for download.  Implied with --no-index.'
complete -f -c pip -l exists-action -d 'Default action when a path already exists: (s)witch, (i)gnore, (w)ipe, (b)ackup.' # <action>
complete -f -c pip -s h -l help -d 'Show help'
complete -f -c pip -l isolated -d 'Run pip in an isolated mode, ignoring environment variables and user configuration.'
complete -f -c pip -l log -d 'Path to a verbose appending log.' # <path>
complete -f -c pip -l no-cache-dir -d 'Disable the cache.'
complete -f -c pip -l proxy -d 'Specify a proxy in the form [user:passwd@]proxy.server:port.' # <proxy>
complete -f -c pip -l retries -d 'Maximum number of retries each connection should attempt (default 5 times).' #<retries>
complete -f -c pip -l timeout -d 'Set the socket timeout (default 15 seconds).' # <sec>
complete -f -c pip -l trusted-host -d 'Mark this host as trusted, even though it does not have valid or any HTTPS.' # <hostname>
complete -f -c pip -s q -l quiet -d 'Give less output.'
complete -f -c pip -s v -l verbose -d 'Give more output. Option is additive, and can be used up to 3 times.'
complete -f -c pip -n '__fish_pip_needs_command' -s V -l version -d 'Show version and exit.'
