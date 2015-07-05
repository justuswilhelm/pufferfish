# Fish Configuration

## Aliases

+ `changelog` ... `git commit CHANGELOG.md -m 'DOC: Update Changelog'`
+ `ga` ... `git add`
+ `gap` ... `git add` in patch mode
+ `gc` ... `git checkout`
+ `gd` ... See which changes are not staged
+ `gdc` ... See which changes are staged
+ `gl` ... `git log`
+ `gm` ... `git commit`
+ `gma` ... `git commit --amend`
+ `gp` ... `git push; or git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`
+ `gs` ... `git status`
+ `pip_install` ... Install all pip requirements in `requirements.txt`
+ `s_env` ... `source env/bin/activate.fish`
+ `hosts` ... `sudo vim /etc/hosts`
+ `latexmk` ... `latexmk -pdf -pvc`
+ `ssh-x` ... `ssh -c arcfour,blowfish-cbc -XC`
+ `dotfiles` ... `cd ~/.dotfiles`

## Functions

### `cd`
Overrides builtin cd and checks whether a Python virtual environment exists in
the current directory and if so, sources `env/bin/activate.fish`.

### `config`
Runs the bootstrap script. Useful for reloading NeoVim configuration and plugins,
and making sure that all symlinks for configuration files have been
created.

### `fish_greeting`
Override of builtin fish_greeting.

### `fish_prompt`
Override of builtin fish_prompt. Adds some useful Git status information.

### `fish_right_prompt`
Override of builtin fish_right_prompt. Adds some useful date/time information.

### `gi`
Create a Git repository in the current directory and add and commit the
following files:

- `README.md`
- `CHANGELOG.md`
- `LICENSE`
- `CONTRIBUTING.md`

### `gtag`
Assuming that you have created a CHANGELOG.md file in your current Git
repository, this function allows you to add a Git tag with the newest release
number in your change log.

### `makeenv`
Create a Python virtual environment. Can be supplied with a path to a Python
runtime in case you need a specific version.

### `mex`
Make a file executable, create it if it doesn't already exist.
