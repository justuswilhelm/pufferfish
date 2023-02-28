" Vim-Plug
  call plug#begin('~/.config/nvim/plugged')
    " Language specific
    Plug 'guersam/vim-j', {'for': 'j'}
    Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
    Plug 'pangloss/vim-javascript', {'for': 'javascript'}
    Plug 'evanleck/vim-svelte', {'branch': 'main'}
    " TODO Still neeeded?
    Plug 'elzr/vim-json', {'for': 'json'}
    Plug 'ElmCast/elm-vim', {'for': 'elm'}
    Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
    Plug 'dag/vim-fish', {'for': 'fish'}
    Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
    Plug 'tpope/vim-markdown', {'for': 'markdown'}

    " Improve editor appearance
    Plug 'Yggdroot/indentLine'
    Plug 'airblade/vim-gitgutter'
    Plug 'dracula/vim'

    " Improve general editor behavior
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'easymotion/vim-easymotion'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'epeli/slimux'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'jeffkreeftmeijer/vim-numbertoggle'
    Plug 'rgroli/other.nvim'
    Plug 'rking/ag.vim'
    Plug 'tpope/vim-surround'
    " TODO Still needed?
    Plug 'tpope/vim-fugitive'

  call plug#end()

" Indentation
  syntax enable
  filetype plugin indent on
  set expandtab
  set shiftwidth=4
  set tabstop=4

" Keyboard shortcuts
  let mapleader = ','
  let maplocalleader = ','
  " Normal Mode
    " Fix TmuxNavigateLeft
      nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
    " Append to end
      nnoremap L $p
      nnoremap K $pkJ
    " Yank till end
      nnoremap Y y$
    " Smarter text navigation
      nnoremap j gj
      nnoremap k gk
    " Pinky pain
      nore ; :
    " Run default macro
      nnoremap <Space> @q
    " Disable highlighting
      nnoremap <leader><space> :noh<cr>

    " Reload configuration
    nnoremap <leader>l :source ~/.config/nvim/init.vim<cr>

  " Make matching a little bit more magical
  " http://vim.wikia.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
    nnoremap / /\v
    vnoremap / /\v
    cnoremap %s/ %s/\v
    cnoremap \>s/ \>s/\v

  " Young Padawan Mode
    inoremap jk <esc>

  " Ctags
    nnoremap <leader>t :CtrlPTag<cr>


  " TODO timestamp
    nmap <leader>ts A Justusjk:r!date "+\%Y-\%m-\%d"<CR>kJ$

  " vim-vsnip
    imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
    nmap <C-y> :VsnipYank<cr>
    vmap <C-y> :VsnipYank<cr>

" Files and folders to ignore
  set wildignore=*/.git/*
  set wildignore+=*/.DS_Store
  set wildignore+=*/vendor
  set wildignore+=*/env/*
  set wildignore+=*.pyc
  set wildignore+=*/__pycache__/
  set wildignore+=*/deps/* " Elixir deps
  set wildignore+=*/_build/* " Elixir builds
  set wildignore+=*/Pods/* " CocoaPods
  set wildignore+=*/node_modules/*
  set wildignore+=*/bower_components/*
  set wildignore+=*/elm-stuff/*
  set wildignore+=*/staticfiles/*
  set wildignore+=*.gch
  set wildignore+=*.o

" ctrlp.vim
  let g:ctrlp_show_hidden=1
  let g:ctrlp_working_path_mode = ''
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Use a different shell
  if &shell =~# 'fish$'
      set shell=sh
  endif

" Netrw
  let g:netrw_altv=1
  let g:netrw_liststyle=3

" Show unprintable characters
  set list
  set listchars=tab:»\ ,nbsp:෴,trail:※
  set colorcolumn=80

" Show commands while they're being typed
  set showcmd

" Slimux
  map <Leader>s :SlimuxREPLSendLine<CR>
  vmap <Leader>s :SlimuxREPLSendSelection<CR>
  map <Leader>a :SlimuxShellLast<CR>
  map <Leader>k :SlimuxSendKeysLast<CR>

" Line numbers
  set number relativenumber

" Folds
  let g:tex_conceal = "" "Has to be one of the most annoying things ever
  set conceallevel=0
  set nofoldenable

" Use system clipboard
  set clipboard+=unnamedplus

" Undo Levels
  set history=1000
  set undolevels=1000

" Matching
  set ignorecase
  set smartcase
  set gdefault
  set incsearch
  set showmatch
  set hlsearch

" Color Stuff
  let g:dracula_italic = 0
  color dracula
  hi Normal ctermbg=none

" Customize Backup Dir location
  set backupdir=~/.config/nvim/backup/

" JSON concealing
  let g:vim_json_syntax_conceal = 0

" Clang-Format
  let g:clang_format#code_style = "llvm"

" Mouse mode
  set mouse=a

" Markdown
  let g:markdown_syntax_conceal = 0

" https://superuser.com/questions/385553/making-the-active-window-in-vim-more-obvious
  augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
  augroup END

" Crontab stuff
  if $VIM_CRONTAB == "true"
      set nobackup
      set nowritebackup
  endif

" ctags
  set tags=./.tags,.tags;

" Why not zoidberg?
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" vim-vsnip
let g:vsnip_snippet_dir = expand('~/.config/nvim/snippets/')

" Autoreload
set autoread

luafile $HOME/.config/nvim/new-init.lua
