{ xdgConfigHome, isDarwin }: {
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
  };
  ignores =
    if isDarwin then [
      ".DS_Store"
    ] else [ ];
  includes = [
    {
      # Create something like this:
      # [user]
      # name = "My name"
      # email = "my@email.address";
      path = "${xdgConfigHome}/git/user";
    }
  ];
}
