{ isDebian }:
let
  debianConfig = ''
    # for ssh-agent
    # Need XDG_RUNTIME_DIR, which is not present over SSH
    if [ -n $XDG_RUNTIME_DIR ]
        set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent
        if [ ! -e $SSH_AUTH_SOCK ]
            echo "Could not find $SSH_AUTH_SOCK" >&2
        end
    end
  '';
in
{
  enable = true;
  loginShellInit =
    if isDebian then ''
      # Only need to source this once
      source /nix/var/nix/profiles/default/etc/profile.d/nix.fish

      # We always want to enable wayland in moz, since we start sway through the terminal
      set -x MOZ_ENABLE_WAYLAND 1

      # If running from tty1 start sway
      set TTY1 (tty)

      if [ $TTY1 = /dev/tty1 ]
          exec sway
      end
    '' else "";
  interactiveShellInit = ''
    # Theme
    # =====
    # TODO make this selenized
    fish_config theme choose "Solarized Light"
    ${if isDebian then debianConfig else ""}'';
  shellAbbrs = {
    # Fish abbreviations
    # ------------------
    # Reload fish session. Useful if config.fish has changed.
    reload = "exec fish";

    # File abbreviations
    # ------------------
    # Ls shortcut with color, humanized, list-based output
    l = "ls -lhaG";

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
    gi = "git init; and git commit --allow-empty -m 'nitial commit'";
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

    # Neovim abbreviations
    # --------------------
    # Start neovim
    e = "nvim";
  };
}