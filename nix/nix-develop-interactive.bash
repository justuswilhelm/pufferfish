#!/usr/bin/env bash
# Source: https://github.com/imincik/nix-utils/blob/166661db4f51ac0d11147ba2a1e73a1fe2aff0f8/nix-develop-interactive.bash
# MIT License

# Copyright (c) 2023 Ivan Mincik
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Interactively run Nix build phases.
# This script must be sourced in Nix development shell environent !

# USAGE:
# nix develop nixpkgs#<PACKAGE>
# source ~/.dotfiles/nix/nix-develop-interactive.bash


# make sure that script is sourced
(return 0 2>/dev/null) && sourced=1 || sourced=0
if [ "$sourced" -eq 0 ]; then
    echo -e "ERROR, this script must be sourced (run 'source $0')."
    exit 1
fi

# make sure that script is sourced from nix shell
(type -t genericBuild &>/dev/null) && in_nix_shell=1 || in_nix_shell=0
if [ "$in_nix_shell" -eq 0 ]; then
    echo -e "ERROR, this script must be sourced from nix shell environment (run 'nix develop nixpkgs#<PACKAGE>')."
    return 1
fi

# Debug SHELL variable
# it appears to be set to fish sometimes
echo "Launched with \$SHELL: $SHELL"

# Go to new temporary directory
tmp="$(mktemp -d)"
echo "Changing to new temporary directory $tmp"
pushd "$tmp" || exit

# # Detect and fix outputs to point to above temporary directory
# for output in $outputs; do
#     fixed_output="$tmp/$output"
#     echo "Fixing directory in outputs '$output' to point to $fixed_output"
#     eval $output=\$fixed_output
# done

# phases detection taken from
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh
declare -a all_phases=(
     "${prePhases[@]}"
     unpackPhase
     patchPhase
     "${preConfigurePhases[@]}"
     configurePhase
     "${preBuildPhases[@]}"
     buildPhase
     checkPhase
     "${preInstallPhases[@]}"
     installPhase
     "${preFixupPhases[@]}"
     fixupPhase
     installCheckPhase
     "${preDistPhases[@]}"
     distPhase
     "${postPhases[@]}"
)

shell="$(which bash)"

# run phases
for phase in "${all_phases[@]}"; do
    phases_pretty=$(echo "${all_phases[*]}" | sed "s|$phase|**$phase**|g" | tr -s '[:blank:]')
    echo -e "\n>>> Phase:   $phases_pretty"
    echo "Current directory: $PWD"
    echo ">>> Command:  SHELL=$shell runPhase $phase"
    echo ">>> Press ENTER to run, CTRL-C to exit"
    read -r

    SHELL=$shell runPhase "$phase"
    status=$?
    echo "Status: $status"
done
