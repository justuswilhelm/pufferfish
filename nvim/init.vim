" Vim-Plug
  call plug#begin('~/.config/nvim/plugged')
    " Language specific
    Plug 'ElmCast/elm-vim', {'for': 'elm'}
    Plug 'amperser/proselint'
    Plug 'dag/vim-fish', {'for': 'fish'}
    Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
    Plug 'fatih/vim-go', {'for': 'go'}
    Plug 'fisadev/vim-isort', {'for': 'python'}
    Plug 'guersam/vim-j', {'for': 'j'}
    Plug 'guns/vim-sexp', {'for': 'lisp'}
    Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}

    " Improve editor appearance
    Plug 'Yggdroot/indentLine'
    Plug 'airblade/vim-gitgutter'
    Plug 'altercation/vim-colors-solarized'
    Plug 'scrooloose/syntastic'

    " Improve general editor behavior
    Plug 'benekastah/neomake'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'easymotion/vim-easymotion'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'kien/ctrlp.vim'
    Plug 'rizzatti/dash.vim'
    Plug 'rking/ag.vim'
    Plug 'Chun-Yang/vim-action-ag'
    Plug 'epeli/slimux'
    Plug 'SirVer/ultisnips'
    Plug 'tpope/vim-surround'

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

  " Matching
    nnoremap / /\v
    vnoremap / /\v

  " Young Padawan Mode
    inoremap jk <esc>
    inoremap <esc> <NOP>
    noremap <Up> <NOP>
    noremap <Down> <NOP>
    noremap <Left> <NOP>
    noremap <Right> <NOP>

  " DashSearch (OS X only with Dash)
    nmap <silent> <leader>d <Plug>DashSearch

    map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Neomake
  autocmd! BufWritePost * Neomake
  let g:neomake_python_enabled_makers=['pep8']
  let g:neomake_elixir_mix_maker = {
        \ 'exe' : 'mix',
        \ 'args': ['compile', '--warnings-as-errors'],
        \ 'cwd': getcwd(),
        \ 'errorformat':
          \ '** %s %f:%l: %m,' .
          \ '%f:%l: warning: %m'
        \ }
  let g:neomake_elixir_enabled_makers = ['mix']
  let g:neomake_html_enabled_makers = []

" Ignore folders
  set wildignore+=*/.git/*
  set wildignore+=*/.DS_Store
  set wildignore+=*/vendor
  set wildignore+=*/env/*
  set wildignore+=*.pyc
  set wildignore+=*/__pycache__/
  set wildignore+=*/node_modules/*
  set wildignore+=*/bower_components/*
  set wildignore+=*/staticfiles/*

" Use a different shell
if &shell =~# 'fish$'
    set shell=sh
endif

" Netrw
  let g:netrw_altv=1
  let g:netrw_liststyle=3

" Syntastic
  let g:syntastic_html_checkers=[]
  let g:syntastic_python_checkers=['pydocstyle']

" Show unprintable characters
  set list
  set listchars=tab:>.,trail:.,extends:#,nbsp:.

  set colorcolumn=80

" Show commands while they're being typed
  set showcmd

" Slimux
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>
map <Leader>a :SlimuxShellLast<CR>
map <Leader>k :SlimuxSendKeysLast<CR>

" Line numbers
  set nu

" Folds
  set foldmethod=indent
  set foldlevelstart=2
  set foldminlines=2
  let g:tex_conceal = "" "Has to be one of the most annoying things ever

" Use system clipboard
  set clipboard=unnamed

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
  set background=light
  colorscheme solarized
  hi Normal ctermbg=none

" Customize Backup Dir location
  set backupdir=~/.config/nvim/backup/
  set directory=~/.config/nvim/swap/
