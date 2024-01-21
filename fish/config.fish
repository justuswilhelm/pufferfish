# Theme
# =====
# TODO make this selenized
fish_config theme choose "Solarized Light"
# Editor
# ======
set -x EDITOR nvim

# Language
# ========
set -x LANG "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"

# Do not track
# ============
# https://consoledonottrack.com/
set -x DO_NOT_TRACK 1
# Homebrew needs its own Extrawurst, boo
set -x HOMEBREW_NO_ANALYTICS 1

# Paths
# =====
set -x DOTFILES "$HOME/.dotfiles"
set -x XDG_CONFIG_HOME "$HOME/.config"
