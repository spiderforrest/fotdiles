" Install vim-plug if not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync
\| endif

call plug#begin('~/.config/nvim/plugged')

" detect keyboard and use remapping plugin
if system("lsusb | grep -c Lily58")
	Plug 'spiderforrest/vim-colemak'
endif
" tie to nnn
Plug 'mcchrish/nnn.vim'
" themes
Plug 'sainnhe/everforest'
Plug 'karoliskoncevicius/sacredforest-vim'
Plug 'shaunsingh/oxocarbon.nvim', { 'do': './install.sh' }
" bar
Plug 'vim-airline/vim-airline'
" undo
Plug 'mbbill/undotree'
" flat window & focus
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
map <silent><leader>g :Goyo<CR>
" run when entering goyo
function! s:goyo_enter()
  set noshowmode
  set noshowcmd
  set scrolloff=999
  noh
  " toggle plugins
  Limelight
  DisableWhitespace
  " hide the ~
  set fillchars=eob:\ ,fold:\ ,vert:\│
  " copy pasted for letting :q quit
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction
" & exiting
function! s:goyo_leave()
  set showmode
  set showcmd
  set scrolloff=10
  Limelight!
  EnableWhitespace
  set fillchars="~":\ ,fold:\ ,vert:\│
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
" phat phuck prediction
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
let g:coq_settings = { 'auto_start': 'shut-up' }
" stats
Plug 'wakatime/vim-wakatime'
" whitespace
Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_ctermcolor=8
" markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" LaTex
Plug 'vim-latex/vim-latex'
Plug 'xuhdev/vim-latex-live-preview'
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
" remote editing
Plug 'jbyuki/instant.nvim'
let g:instant_username = "$HOSTNAME"
" autoformat/align
Plug 'junegunn/vim-easy-align'
" grammer/spell
Plug 'rhysd/vim-grammarous'
" tone? checker
Plug 'reedes/vim-wordy'
" unchecked
Plug 'vigoux/LanguageTool.nvim'

Plug 'ron89/thesaurus_query.vim'
Plug 'reedes/vim-pencil'
"Plug 'thaerkh/vim-workspace'
let g:workspace_session_directory = $HOME . '/.config/nvim/sessions/'
vnoremap <silent> <Enter> :EasyAlign<cr>

call plug#end()

colorscheme everforest
syntax on
set shiftwidth=4
set tabstop=4
set softtabstop=4
set scrolloff=5
set shiftwidth=4
set expandtab
set smartindent
set linebreak
set showmatch
set showbreak=»
set smartcase
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set showmatch
set confirm
set ruler
set autochdir
set autowriteall
set undolevels=1000
set backspace=indent,eol,start
set ignorecase
set smartcase
set history=10000
set nonumber
set wrap
set spell
set mousehide

nnoremap <silent><leader>s :%s/ //g<CR>ggVG:EasyAlign *
nnoremap <silent><leader>f :CHADopen<CR>
nnoremap <silent><leader>u :UndotreeToggle<CR>
nnoremap <silent><leader>d "_d
nnoremap <silent><leader>y "*y
nnoremap <silent><leader>Y "*Y
nnoremap <silent><leader>p "*p
nnoremap <silent><leader>P "*P
nnoremap <silent><leader>/ :noh<CR>
nnoremap <F5> :set linebreak<CR>
nnoremap <F6> :set nolinebreak<CR>
function! Edit()
    LanguageToolCheck
    LanguageToolSummery
endfunc
" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" okay i have a reasonable explaination for this, i use keyboard mouse
" emulation and it's actually pretty fast & convient-i swear i ain't reach 4shit
function! ToggleMouse()
    if &mouse == 'nvi'
        set mouse=
    else
        set mouse=nvi
    endif
endfunc
nnoremap <silent><leader>m :call ToggleMouse()<cr>

" Reload vim-colemak to remap any overridden keys
silent! source "$HOME/.config/nvim/plugged/vim-colemak/plugin/colemak.vim"
