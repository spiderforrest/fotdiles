
-- {{{ var defines
-- shorthands
fn = vim.fn
vs = vim.cmd
set = vim.opt
g = vim.g
vs = vim.cmd
fn = vim.fn
map = vim.api.nvim_set_keymap
lmap = vim.keymap.set
bindopt = { noremap = true, silent = true }

g.mapleader = ' ' -- setting leader before plugins initialize
-- get the path for plugins and add it to vim's version of PATH
lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
set.rtp:prepend(lazypath)
-- }}}

-- {{{ functions and whatnot
-- {{{ lualine
function line_sym_1()
    return '🕷'
end
function line_sym_2()
    return '🕸️'
end
function line_wc()
    -- print selectionwords or cursorpos/total
    return tostring(fn.wordcount().visual_words or fn.wordcount().cursor_words) .. "/" .. tostring(fn.wordcount().words)
end
-- }}}

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

-- {{{ writing mode!
vs [[ function! s:goyo_enter()
    set nonumber
    set norelativenumber
    set wrap
    set spell
    set scrolloff=5
    set noshowmode
    set noshowcmd
    set fo-=t
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
  set number
  set relativenumber
  set nowrap
  set nospell
  set showmode
  set showcmd
  set fo+=t
  set scrolloff=3
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
-- }}}


-- vim:foldmethod=marker
