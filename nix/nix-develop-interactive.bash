#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2023 Ivan Mincik
# SPDX-License-Identifier: MIT
# Source: https://github.com/imincik/nix-utils/blob/166661db4f51ac0d11147ba2a1e73a1fe2aff0f8/nix-develop-interactive.bash
#
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

# Detect and fix outputs to point to above temporary directory
for output in ${outputs:?}; do
    fixed_output="$tmp/$output"
    echo "Fixing directory in outputs '$output' to point to $fixed_output"
    eval "$output"=\$fixed_output
done

# phases detection taken from
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh
IFS=' '
read -ra prePhasesArr <<< "${prePhases:-}"
read -ra preConfigurePhasesArr <<< "${preConfigurePhases:-}"
read -ra preBuildPhasesArr <<< "${preBuildPhases:-}"
read -ra preInstallPhasesArr <<< "${preInstallPhases:-}"
read -ra preFixupPhasesArr <<< "${preFixupPhases:-}"
read -ra preDistPhasesArr <<< "${preDistPhases:-}"
read -ra postPhasesArr <<< "${postPhasesArr:-}"

declare -a all_phases=(
     "${prePhasesArr[@]}"
     unpackPhase
     patchPhase
     "${preConfigurePhasesArr[@]}"
     configurePhase
     "${preBuildPhasesArr[@]}"
     buildPhase
     checkPhase
     "${preInstallPhasesArr[@]}"
     installPhase
     "${preFixupPhasesArr[@]}"
     fixupPhase
     installCheckPhase
     "${preDistPhasesArr[@]}"
     distPhase
     "${postPhasesArr[@]}"
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
