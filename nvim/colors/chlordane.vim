" Name: chlordane.vim
" Maintainer:   Kojo Sugita
" Last Change:  2008-11-22
" Revision: 1.2

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = 'chlordane'

hi Boolean      guifg=#77dd88 guibg=#354535
hi Char         guifg=#77dd88 guibg=#354535
hi ColorColumn  guibg=#0a0a0a
hi Comment      guifg=#446644
hi Constant     guifg=#88ee99 gui=none
hi Cursor       guifg=#3a553a guibg=#77dd88
hi CursorIM     guifg=#3a553a guibg=#77dd88
hi CursorLine   guibg=#000000 gui=underline
hi DiffAdd      guifg=#77dd88 guibg=#3a553a gui=none
hi DiffChange   guifg=#77dd88 guibg=#3a553a gui=none
hi DiffDelete   guifg=#223322 guibg=#223322 gui=none
hi DiffText     guifg=#77dd88 guibg=#448844 gui=bold
hi Directory    guifg=#77dd88 guibg=#000000 gui=bold
hi ErrorMsg     guifg=#ee1111 guibg=#000000
hi Error        guifg=#eeaaaa guibg=#000000
hi FoldColumn   guifg=#557755 guibg=#102010
hi Folded       guifg=#55af66 guibg=#000000
hi Identifier   guifg=#77dd88
hi IncSearch    guifg=#3a553a guibg=#77dd88 gui=none
hi LineNr       guifg=#446644 guibg=#000000 gui=none
hi ModeMsg      guifg=#55af66 guibg=#000000
hi MoreMsg      guifg=#55af66 guibg=#000000
hi NonText      guifg=#606060 gui=none
hi Normal       guifg=#55af66 guibg=#000000
hi Number       guifg=#77dd88 guibg=#354535
hi OverColumn   guibg=#0a0a0a
hi Question     guifg=#55af66 guibg=#000000
hi Search       guifg=#223322 guibg=#55af66 gui=none
hi Special      guifg=#55af66 guibg=#223333 gui=bold
hi Statement    guifg=#88ee99 gui=none
hi StatusLine   guifg=#88ee99 guibg=#447f55 gui=bold
hi StatusLineNC term=bold cterm=bold,underline ctermfg=green ctermbg=Black
hi StatusLineNC term=bold gui=bold,underline guifg=#3a553a  guibg=Black
hi String       guifg=#77dd88 guibg=#354535
hi Title        guifg=#77dd88 guibg=#223322 gui=bold
hi VertSplit    guifg=#223322 guibg=#223322
hi Visual       guifg=#77dd88 guibg=#448844 gui=none
hi VisualNOS    guifg=#55af66 guibg=#000000
hi WarningMsg   guifg=#77dd88 guibg=#000000
hi WildMenu     guifg=#3a553a guibg=#77dd88
hi lCursor      guifg=#3a553a guibg=#77dd88

"Procedure name
hi Function     guifg=#77dd88

"Define, def
hi PreProc      guifg=#77dd88 gui=bold
hi Type         guifg=#77dd88 gui=bold
hi Underlined   guifg=#77dd88 gui=underline
hi Error        guifg=#ee1111 guibg=#000000
hi Todo         guifg=#223322 guibg=#55af66 gui=none
hi SignColumn   guibg=#000000
