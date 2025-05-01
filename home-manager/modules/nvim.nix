{ lib, pkgs, config, ... }:
{
  xdg.configFile = {
    "nvim/after".source = ../../nvim/after;
    "nvim/colors/selenized.vim".source = ../../nvim/colors/selenized.vim;
    "nvim/init_base.lua".source = ../../nvim/init_base.lua;
    "nvim/autoload/plug.vim".source = ../../nvim/autoload/plug.vim;
    "nvim/snippets" = {
      source = ../../nvim/snippets;
      recursive = true;
    };
  };

  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ../../nvim/init.lua;
    defaultEditor = true;
    extraPackages = [
      pkgs.deno
      pkgs.ruff
      pkgs.ruff-lsp
      pkgs.vale-ls
      pkgs.pyright
      pkgs.typescript
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.svelte-language-server
    ];
    extraPython3Packages = python3Packages: [
      # Pillow needed for pastify
      python3Packages.pillow
    ];
  };

  home.activation.performNvimUpdate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH=${pkgs.git}/bin:${pkgs.gcc}/bin:$PATH
    $DRY_RUN_CMD exec ${config.programs.neovim.finalPackage}/bin/nvim \
      --headless \
      +"PlugUpdate --sync" +qa
  '';

  programs.fish.shellAbbrs = {
      # Neovim abbreviations
      # --------------------
      # Start neovim
      e = "nvim";
  };
}
