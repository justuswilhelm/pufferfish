" Vim-Plug
  call plug#begin('~/.config/nvim/plugged')
    " Language specific
    Plug 'ElmCast/elm-vim', {'for': 'elm'}
    Plug 'amperser/proselint'
    Plug 'dag/vim-fish', {'for': 'fish'}
    Plug 'elzr/vim-json', {'for': 'json'}
    Plug 'fatih/vim-go', {'for': 'go'}
    Plug 'fisadev/vim-isort', {'for': 'python'}
    Plug 'gfontenot/vim-xcode'
    Plug 'guersam/vim-j', {'for': 'j'}
    Plug 'guns/vim-sexp', {'for': 'lisp'}
    Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
    Plug 'justuswilhelm/vim-racket', {'for': 'racket'}
    Plug 'rubik/vim-dg', {'for': 'dg'}

    " Improve editor appearance
    Plug 'Yggdroot/indentLine'
    Plug 'airblade/vim-gitgutter'
    Plug 'altercation/vim-colors-solarized'
    Plug 'dracula/vim'

    " Improve general editor behavior
    Plug 'Chun-Yang/vim-action-ag'
    Plug 'benekastah/neomake'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'easymotion/vim-easymotion'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'epeli/slimux'
    Plug 'qpkorr/vim-renamer'
    Plug 'rizzatti/dash.vim'
    Plug 'rking/ag.vim'
    Plug 'tpope/vim-fugitive'
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

    " Reload configuration
    nnoremap <leader>l :source ~/.config/nvim/init.vim<cr>

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
    nmap <silent> <leader>d <Plug>DashGlobalSearch

  " Clang-Format
    nmap <silent> <leader>c :ClangFormat<cr>
    vmap <silent> <leader>c :ClangFormat<cr>


  " TODO timestamp
    nmap <leader>ts A Justusjk:r!date "+\%Y-\%m-\%d"<CR>kJ$

" Neomake
  autocmd! BufWritePost * Neomake
  let g:neomake_python_enabled_makers=['flake8', 'pep257', 'python']
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
  " https://github.com/neomake/neomake/issues/228
  let g:neomake_javascript_enabled_makers = ['eslint']
  let g:neomake_cpp_enabled_makers = []

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

" Use a different shell
if &shell =~# 'fish$'
    set shell=sh
endif

" Netrw
  let g:netrw_altv=1
  let g:netrw_liststyle=3

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
  set number

" Folds
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

" JSON concealing
let g:vim_json_syntax_conceal = 0

" Clang-Format
let g:clang_format#code_style = "llvm"

" Mouse mode
set mouse=a

" Why not zoidberg?
