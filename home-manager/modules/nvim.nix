{ lib, pkgs, config, ... }:
{
  xdg.configFile = {
    "nvim/after".source = ../../nvim/after;
    "nvim/colors/selenized.vim".source = ../../nvim/colors/selenized.vim;
    "nvim/init_base.lua".source = ../../nvim/init_base.lua;
    "nvim/lua".source = ../../nvim/lua;
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
    plugins = with pkgs.vimPlugins; [
      # Language specific
      # -----------------
      # mrcjkb/rustaeceanvim
      rustaceanvim
      # ledger/vim-ledger
      vim-ledger
      # othree/html5.vim
      html5-vim
      # hynek/vim-python-pep8-indent
      # If this isn't enabled, indentation on the next line is wrong.
      vim-python-pep8-indent
      # Ascii stuff
      # -----------
      # jbyuki/venn.nvim
      venn-nvim
      # LSP Config
      # ----------
      # neovim/nvim-lspconfig
      nvim-lspconfig
      # hrsh7th/cmp-nvim-lsp
      cmp-nvim-lsp
      # Search and file jump
      # --------------------
      # ibhagwan/fzf-lua
      fzf-lua
      # tmux interaction
      # ----------------
      # christoomey/vim-tmux-navigator
      vim-tmux-navigator
      # treesitter
      # ----------
      # nvim-treesitter/nvim-treesitter
      nvim-treesitter.withAllGrammars
      # kylechui/nvim-surround
      # works with treesitter
      nvim-surround
      # jeffkreeftmeijer/vim-numbertoggle
      vim-numbertoggle
      # easymotion/vim-easymotion
      vim-easymotion
      # Git
      # ---
      # tpope/vim-fugitive
      vim-fugitive
    ];
    extraPackages = [
      pkgs.tree-sitter
      pkgs.git
      pkgs.gcc

      # Needed for plugins
      # ==================
      pkgs.silver-searcher
      pkgs.ripgrep
      # fzf-lua
      pkgs.fzf

      # Language servers
      # ================
      # rust
      # rustup component add rust-analyzer
      # pkgs.rust-analyzer
      # JavaScript
      # ----------
      pkgs.deno
      pkgs.typescript
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.svelte-language-server
      # Python
      # ------
      pkgs.ruff
      # ruff claims to now have a lsp server and the following package
      # disappeared from nix 25.05
      # pkgs.ruff-lsp
      pkgs.pyright
      pkgs.vale-ls
    ];
    extraPython3Packages = python3Packages: [
      # Pillow needed for pastify
      python3Packages.pillow
    ];
  };

  home.activation.performNvimUpdate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${config.programs.neovim.finalPackage}/bin/nvim --headless \
      +"PlugUpdate --sync" +qa
  '';

  programs.fish.shellAbbrs = {
    # Neovim abbreviations
    # --------------------
    # Start neovim
    e = "nvim";
  };
}
