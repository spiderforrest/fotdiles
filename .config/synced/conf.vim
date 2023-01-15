" Spider's multimode vim config

"                            
" () | _        _  ,_  o  _  
" /\/||/ /|/|  |/ /  | | /   
"/(_/ |_/ | |_/|_/   |/|/\__/
"                            
"
"
"
" Install vim-plug if not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
" Run PlugInstall if there are missing plugins
au VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync
\| endif

call plug#begin('~/.config/nvim/plugged')

" detect keyboard and use remapping plugin
if system("lsusb | grep -c Lily58")
	Plug 'spiderforrest/vim-colemak'
endif
" file managers
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
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
let g:coq_settings = {
    \'auto_start': 'shut-up' ,
    \'limits.completion_manual_timeout': 3,
    \'display': {
        \'pum.fast_close': v:false ,
        \'ghost_text.context': [" ",""] ,
        \'pum.kind_context': [" 「",""] ,
        \'pum.source_context': [" | ","」"],
        \'preview.border': 'solid',
    \}
\}

Plug 'mattn/emmet-vim'
" undo
Plug 'mbbill/undotree'
" stats
Plug 'wakatime/vim-wakatime'
" whitespace
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_ctermcolor=8
" lint
Plug 'dense-analysis/ale'
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\}
let g:ale_fix_on_save = 1
let g:airline#extensions#ale#enabled = 1


" autocommenter
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-commentary'
" markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" latex
Plug 'vim-latex/vim-latex'
" remote editing
Plug 'jbyuki/instant.nvim'
let g:instant_username = "$HOSTNAME"
" autoformat/align
Plug 'junegunn/vim-easy-align'
" text wrappers
Plug 'tpope/vim-surround'
Plug 'kien/rainbow_parentheses.vim'
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
au Syntax * RainbowParenthesesLoadChevrons
" code checking, install shellcheck for bash
Plug 'vim-syntastic/syntastic'
" cpp syntax
Plug 'bfrg/vim-cpp-modern'
" rust shit
Plug 'rust-lang/rust.vim'
syntax enable
filetype plugin indent on
" git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

call plug#end()

colorscheme everforest
" simple sets i like
syntax on
set shiftwidth=4
set tabstop=4
set softtabstop=4
set scrolloff=2
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
set nowrap
set textwidth=100
set number
set relativenumber
" highlght colmn 80
if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=0
endif


" call plugins
nnoremap <silent><leader>f :CHADopen<CR>
nnoremap <silent><leader>u :UndotreeToggle<CR>
nnoremap <silent><leader>g :Goyo<CR>
vnoremap <silent> <Enter> :EasyAlign<CR>
nnoremap <silent><leader>e ysj<em><CR>
" easyalign entire buffer
nnoremap <silent><leader>s :%s/ //g<CR>ggVG:EasyAlign *

" dump delete and copy/paste with clipboard
nnoremap <silent><leader>d "_d
nnoremap <silent><leader>y "*y
nnoremap <silent><leader>Y "*Y
nnoremap <silent><leader>p "*p
nnoremap <silent><leader>P "*P
" clear seach highlight
nnoremap <silent><leader>/ :noh<CR>
" diff shit
nnoremap <silent><leader>tg :diffget<CR>
nnoremap <silent><leader>tp :diffput<CR>
nnoremap <silent><leader>tt :diffthis<CR>
" where the fuck is my cursor again
nnoremap <silent><leader>c :set invcursorline<CR>:set invcursorcolumn<CR>
" toggle wrap
nnoremap <F5> :set linebreak<CR>
nnoremap <F6> :set nolinebreak<CR>
" see ToggleMouse()
nnoremap <silent><leader>m :call ToggleMouse()<cr>
" edits macro
nnoremap <silent><leader>q  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
" live webserver
" :h job-control
nnoremap <silent><leader>jl :execute 'silent !live-server &' | :redraw!

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

" Reload vim-colemak to remap any overridden keys
silent! source "$HOME/.config/nvim/plugged/vim-colemak/plugin/colemak.vim"
" it's a lot simpler to do in lua so
" LSP lua bindings


lua << EOF

-- lsp/lint/etc manager
require("mason").setup()
require("mason-lspconfig").setup()

-- lsp header
local lsp = require "lspconfig"
local coq = require "coq"

-- lsp list, just follow the formula i am aware i could simplify this but i don't know lua so
lsp.rome.setup{}
lsp.rome.setup(coq.lsp_ensure_capabilities{})
lsp.html.setup{}
lsp.html.setup(coq.lsp_ensure_capabilities{})
lsp.eslint.setup{}
lsp.eslint.setup(coq.lsp_ensure_capabilities{})
lsp.cssls.setup{}
lsp.cssls.setup(coq.lsp_ensure_capabilities{})
lsp.clangd.setup{}
lsp.clangd.setup(coq.lsp_ensure_capabilities{})
lsp.bashls.setup{}
lsp.bashls.setup(coq.lsp_ensure_capabilities{})
lsp.jsonls.setup{}
lsp.jsonls.setup(coq.lsp_ensure_capabilities{})
lsp.vimls.setup{}
lsp.vimls.setup(coq.lsp_ensure_capabilities{})
--2lazy to figure out custom shit

--lsp.grammerly.setup{}
--lsp.grammerly.setup(coq.lsp_ensure_capabilities{})


-- custom sources
require("coq_3p"){
    -- my configs being outside $NVIM_HOME break this, and i don't want it to spam me
    -- nvim lua config completion
--    { src = "nvimlua", short_name = "nCFL", conf_only: false },
    -- math completion
    { src = "bc", short_name = "MATH", precision = 6 },

    -- lol
    { src = "cow", trigger = "!cow" },

    -- banner
    { src = "figlet", short_name = "BAN", trigger = "!ban"},

    -- shell output pipe
    {
      src = "repl",
      short_name = "BASH",
      sh = "bash",
      max_lines = 99,
      deadline = 500,
      -- christ this is gonna fuck me over
      unsafe = { "rm", "poweroff", "reboot", "mv", "cp", "rmdir" }
    },
}

EOF
