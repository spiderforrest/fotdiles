-- ini.lua

-- {{{ plugin call
dofile(vim.fn.stdpath("config") .. "/plugins.lua")
-- }}}

-- {{{ defines
vim.g.mapleader = ' '
local vs = vim.cmd
local fn = vim.fn
local g = vim.g
local map = vim.api.nvim_set_keymap
local lmap = vim.keymap.set
local set = vim.opt
local plug = vim.fn['plug#']
local bindopt = { noremap = true, silent = true }
local telescope = require('telescope.builtin')
-- }}}

-- {{{ just settings :)
set.shiftwidth=4
set.tabstop=4
set.softtabstop=4
set.scrolloff=2
set.shiftwidth=4
set.expandtab = true
set.smartindent = true
set.linebreak = true
set.showmatch = true
set.showbreak = '»'
set.smartcase = true
-- DO NOT TOUCH THIS WHY THE FUCK IS IT SYMLINKING TO MY HOME DIRECTORY
vs('set undodir=~/.config/nvim/undodir')
set.undofile = true
set.incsearch = true
set.showmatch = true
set.confirm = true
set.ruler = true
set.autochdir = true
--set.autowriteall
set.undolevels=1000
set.backspace='indent,eol,start'
set.ignorecase = true
set.smartcase = true
set.history=10000
set.wrap = false
set.virtualedit = 'block'
set.textwidth=135
set.number = true
set.relativenumber = true

-- for wrting
-- set number = false
-- set relativenumber = false
-- set wrap
-- set spell
-- set scrolloff = 5
-- }}}

-- {{{ unused fuzzy
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
--require('telescope').setup {
--  extensions = {
--    fzf = {
--      fuzzy = true,                    -- false will only do exact matching
--      override_generic_sorter = true,  -- override the generic sorter
--      override_file_sorter = true,     -- override the file sorter
--      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
--                                       -- the default case_mode is "smart_case"
--    }
-- }
--}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
--require('telescope').load_extension('fzf') -- }}}

-- {{{ neovide
set.guifont = { "Space Mono", "h6" }
set.linespace=2
g.neovide_hide_mouse_when_typing = true
g.neovide_remember_window_size = false
g.neovide_fullscreen = false
g.neovide_cursor_animation_length = 0.08
g.neovide_cursor_trail_size = 0.2
g.neovide_cursor_vfx_particle_curl = 0.6
g.neovide_cursor_vfx_particle_density = 14
g.neovide_cursor_vfx_particle_lifetime = 3
g.neovide_cursor_vfx_opacity = 200
-- g.neovide_cursor_vfx_mode = "railgun"
g.neovide_cursor_vfx_mode = "pixiedust"
-- g.neovide_cursor_vfx_mode = "ripple"



-- }}}

-- {{{ theme
-- options are light, dark, and null
set.background='dark'
-- options are gelatin, cookie, cocoa, and chocolate
g.everforest_background = 'gelatin'
g.airline_theme = 'everforest'
--vs('colorscheme everforest') -- }}}

-- {{{ binds
-- call plugins
map('v', '<Enter>',    ':EasyAlign<CR>', bindopt)
map('n', '<leader>f',  ':CHADopen<CR>', bindopt)
map('n', '<leader>u',  ":UndotreeToggle<CR>", bindopt)
map('n', '<leader>g',  ':Goyo<CR>', bindopt)
map('n', '<leader>e',  'ysj<em><CR>', bindopt)
lmap('n', '<leader>tf', function() telescope.find_files() end, bindopt)
lmap('n', '<leader>tg', function() telescope.live_grep() end, bindopt)
lmap('n', '<leader>tb', function() telescope.buffers() end, bindopt)
lmap('n', '<leader>th', function() telescope.help_tags() end, bindopt)
lmap('n', 'f', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end, bindopt)
lmap('n', '<leader>w', function() MiniMap.toggle() end, bindopt)
-- nav buffers
map('n', '<leader>bn', ':bn<CR>', bindopt)
map('n', '<leader>bp', ':bp<CR>', bindopt)
-- external clipboard stuff
map('n', '<leader>d',  '"_d', bindopt)
map('n', '<leader>y',  '"+y', bindopt)
map('n', '<leader>Y',  '"+Y', bindopt)
map('n', '<leader>p',  '"+p', bindopt)
map('n', '<leader>P',  '"+P', bindopt)
map('v', '<leader>d',  '"_d', bindopt)
map('v', '<leader>y',  '"+y', bindopt)
map('v', '<leader>Y',  '"+Y', bindopt)
map('v', '<leader>p',  '"+p', bindopt)
map('v', '<leader>P',  '"+P', bindopt)
-- clear highlighting
map('n', '<leader>/',  ':noh<CR>', bindopt)
-- diffs
map('n', '<leader>tg', ':diffget<CR>', bindopt)
map('n', '<leader>tp', ':diffput<CR>', bindopt)
map('n', '<leader>tt', ':diffthis<CR>', bindopt)
-- i am blind as hell
map('n', '<leader>r',  ':set invrelativenumber<CR>', bindopt)
map('n', '<leader>c',  ':set invcursorline<CR>:set invcursorcolumn<CR>', bindopt)
-- lazy wrap toggles
map('n', '<F5>',       ':set linebreak<CR>', bindopt)
map('n', '<F6>',       ':set nolinebreak<CR>', bindopt)
-- please see ToggleMouse for an explaination, my shame is immeasurable
map('n', '<leader>m',  ':call ToggleMouse()<cr>', bindopt)
-- toss open live-server in a new term
map('n', '<leader>js', ':silent !alacritty -e "live-server" &<CR>:redraw!<CR>', bindopt)
map('n', '<leader>jn', ':silent !alacritty -e "npm start" &<CR>:redraw!<CR>', bindopt)

-- Reload vim-colemak to remap any overridden keys
vs('silent! source "$HOME/.config/nvim/plugged/vim-colemak/plugin/colemak.vim"')
-- }}}

-- {{{ functions and whatnot
-- highlght colmn 80
vs [[ if (exists('+colorcolumn'))
    set colorcolumn=100
    highlight ColorColumn ctermbg=0
endif ]]

-- When editing a file, always jump to the last known cursor position.
vs [[ au BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif ]]

-- okay i have a reasonable explaination for this, i use keyboard mouse
-- emulation and it's actually pretty fast & convient-i swear i ain't reach 4shit
vs [[function! ToggleMouse()
    if &mouse == 'nvi'
        set mouse=
    else
        set mouse=nvi
    endif
endfunc ]]

-- writing mode!
vs [[ function! s:goyo_enter()
    set noshowmode
    set noshowcmd
    set scrolloff=999
    noh
    " toggle plugins
    Limelight
    " hide the ~
    set fillchars=eob:\ ,fold:\ ,vert:\│
    " copy pasted for letting :q quit
    let b:quitting = 0
    let b:quitting_bang = 0
    autocmd QuitPre <buffer> let b:quitting = 1
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction
function! s:goyo_leave()
  set showmode
  set showcmd
  set scrolloff=10
  Limelight!
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
autocmd! User GoyoLeave nested call <SID>goyo_leave() ]]
-- }}}

-- {{{ lsp and girlcoq
-- lsp/lint/etc manager
require("mason").setup()
require("mason-lspconfig").setup()

-- lsp header
local lsp = require "lspconfig"
local coq = require "coq"

-- lsp list, just follow the formula i am aware i could simplify this but i don't know lua so
lsp.html.setup{}
lsp.html.setup(coq.lsp_ensure_capabilities{})
lsp.eslint.setup{}
lsp.eslint.setup(coq.lsp_ensure_capabilities{})
lsp.cssls.setup{}
lsp.cssls.setup(coq.lsp_ensure_capabilities{})
lsp.clangd.setup{}
lsp.clangd.setup(coq.lsp_ensure_capabilities{})
lsp.rome.setup{}
lsp.rome.setup(coq.lsp_ensure_capabilities{})
lsp.bashls.setup{}
lsp.bashls.setup(coq.lsp_ensure_capabilities{})
lsp.jsonls.setup{}
lsp.jsonls.setup(coq.lsp_ensure_capabilities{})
lsp.vimls.setup{}
lsp.vimls.setup(coq.lsp_ensure_capabilities{})
--2lazy to figure out custom shit
--lsp.grammerly.setup{}
--lsp.grammerly.setup(coq.lsp_ensure_capabilities{})

-- custom sources for completion
require("coq_3p"){
    { src = "nvimlua", short_name = "nCFL", conf_only = false },
    -- math completion
    { src = "bc", short_name = "MATH", precision = 6 },
    -- lol
    { src = "cow", trigger = "!cow" },
    -- banner
    { src = "figlet", short_name = "BAN", trigger = "!ban"},
    -- shell output pipe. soo sketchy. soo great.
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
-- }}}


-- vim:foldmethod=marker
