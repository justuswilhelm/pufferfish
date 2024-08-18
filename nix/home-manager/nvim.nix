{ lib, pkgs, config, specialArgs, ... }:
{
  xdg.configFile = {
    nvimAfter = {
      source = ../../nvim/after;
      target = "nvim/after";
    };
    nvimSelenized = {
      source = ../../nvim/colors/selenized.vim;
      target = "nvim/colors/selenized.vim";
    };
    nvimInitBase = {
      source = ../../nvim/init_base.lua;
      target = "nvim/init_base.lua";
    };
    nvimPlug = {
      source = ../../nvim/autoload/plug.vim;
      target = "nvim/autoload/plug.vim";
    };
    nvimSnippets = {
      source = ../../nvim/snippets;
      target = "nvim/snippets";
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
      pkgs.nodePackages.pyright
    ];
    extraPython3Packages = python3Packages: [
      python3Packages.pillow
    ];
  };

  home.activation.performNvimUpdate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH=${pkgs.git}/bin:${pkgs.gcc}/bin:$PATH
    $DRY_RUN_CMD exec ${config.programs.neovim.finalPackage}/bin/nvim \
      --headless \
      +"PlugUpdate --sync" +qa
  '';
}
