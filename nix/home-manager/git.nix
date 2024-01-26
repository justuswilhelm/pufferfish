{ xdgConfigHome, isDarwin }: {
  enable = true;
  # TODO try these out
  # difftastic = { enable = true; };
  # delta = { enable = true; };
  extraConfig = {
    pull = {
      rebase = true;
    };
    rebase = {
      autostash = true;
    };
    commit = {
      verbose = true;
    };
    init = {
      defaultBranch = "main";

    };
    diff = {
      tool = "vimdiff";
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
