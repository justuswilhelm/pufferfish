# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib, pkgs, config, ... }:
{
  home.packages = [
    pkgs.git-annex
    # For git annex p2p
    pkgs.magic-wormhole
  ];
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        light = true;
      };
    };
    extraConfig = {
      pull = {
        rebase = false;
      };
      rebase = {
        autostash = true;
        # Make sure we run git rebase with --rebase-merges
        # to not accidentally make merge commits disappear
        rebaseMerges = true;
      };
      commit = {
        verbose = true;
      };
      init = {
        defaultBranch = "main";

      };
      diff = {
        tool = "vimdiff";
        algorithm = "histogram";
      };
      "diff \"sqlite3\"" = {
        binary = true;
        # https://stackoverflow.com/questions/13271643/git-hook-for-diff-sqlite-table/21789167#21789167
        textconv = "echo .dump | sqlite3";
      };
      merge = {
        tool = "vimdiff";
      };
      "mergetool \"vimdiff\"" = {
        path = "nvim";
      };
      fetch = {
        prune = true;
      };
      annex = {
        autocommit = false;
        synccontent = true;
      };
      http = {
        version = "HTTP/1.1";
      };
    };
    includes = [
      {
        # Create something like this:
        # [user]
        # name = "My name"
        # email = "my@email.address";
        path = "${config.xdg.configHome}/git/user";
      }
    ];
  };
  programs.fish.shellAbbrs = {
    # Git abbreviations
    # -----------------
    # Stage changed files in git index
    ga = "git add";
    # Stage changes in files in patch mode
    gap = "git add -p";
    # Check out a branch or file
    gc = "git checkout";
    # Check out a new branch
    gcb = "git checkout -b";
    # Cherry pick
    gcp = "git cherry-pick";
    # Abort cherry pick
    gcpa = "cherry-pick --abort";
    # Continue cherry picking
    gcpc = "git cherry-pick --continue";
    # Show the current diff for unstaged changes
    gd = "git diff";
    # Show the current diff for staged changes
    gdc = "git diff --cached";
    # Show commit statistics for staged changes
    gds = "git diff --shortstat --cached";
    # Fetch from default remote branch
    gf = "git fetch";
    # Fetch from all remote branches
    gfa = "git fetch --all";
    # Initialize an empty repository
    gi = "git init; and git commit --allow-empty -m 'Initial commit'";
    # Show the git log
    gl = "git log";
    # Show the git log in patch mode
    glp = "git log -p";
    # Commit the current staged changes
    gm = "git commit";
    # Amend to the previous commit
    gma = "git commit --amend";
    # Commit the current staged changes with a message
    gmm = "git commit -e -m";
    # Push to remote
    gp = "git push";
    # Push to remote and force update (potentially dangerous)
    gpf = "git push --force";
    # Bring current branch up to date with a rebase
    gpr = "git pull --rebase";
    # Push and create branch if it has not yet been created remotely
    gpu = "git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)";
    # Show remote repositories
    gr = "git remote";
    # Abort a rebase
    gra = "git rebase --abort";
    # Continue with the next rebase step
    grc = "git rebase --continue";
    # Perform interactive rebase
    gri = "git rebase -i";
    # Perform interactive rebase on origin/master
    grio = "git rebase -i origin/master";
    # Perform interactive rebase on origin/main
    griom = "git rebase -i origin/main";
    # Perform interactive rebase on origin/development
    griod = "git rebase -i origin/development";
    # Rebase current branch from origin/master
    gro = "git fetch --all; and git rebase origin/master";
    # Rebase current branch from origin/development
    grod = "git fetch --all; and git rebase origin/development";
    # Reset current branch to origin master (dangerous)
    groh = "git reset origin/master --hard";
    # Rebase current branch from origin/master
    grom = "git fetch --all; and git rebase origin/main";
    # Show current status
    gs = "git status";
  };
}
