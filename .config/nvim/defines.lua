
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
expopt = { silent = true, noremap = true, expr = true }

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

-- tree surfur jump matcher, true jumps forward false jumps back
function jumpNode(direction)
  require('syntax-tree-surfer').filtered_jump({
		"function",
        "if_statement",
		"else_clause",
		"else_statement",
		"elseif_statement",
		"for_statement",
		"while_statement",
		"switch_statement",
	}, direction)
end

-- highlght colmn 80
vs [[ if (exists('+colorcolumn'))
    set colorcolumn=100
    highlight ColorColumn ctermbg=0
endif ]]

-- turn off fancy colors cos its orang on my phone lol
-- good lord i use vim regularly on my phone
if (fn.system('echo $TERM'):find('xterm')) then
    vs [[au VimEnter * set notermguicolors]]
  end

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
inWritingMode = false
function writing() -- lua function to toggle the writing mode
  if not inWritingMode then
    vs [[
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
      Goyo
      " hide the ~
      set fillchars=eob:\ ,fold:\ ,vert:\│
      " copy pasted for letting :q quit
      let b:quitting = 0
      let b:quitting_bang = 0
      autocmd QuitPre <buffer> let b:quitting = 1
      cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
    ]]
    inWritingMode = true
  else
    vs [[
      set number
      set relativenumber
      set nowrap
      set nospell
      set showmode
      set showcmd
      set fo+=t
      set scrolloff=3
      Limelight!
      Goyo
      set fillchars="~":\ ,fold:\ ,vert:\│
      " Quit Vim if this is the only remaining buffer
      if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if b:quitting_bang
          qa!
        else
          qa
        endif
      endif
    ]]
  inWritingMode = false
  end
end

-- }}}

-- set several keybinds to emulate a new visual mode, for navigating/editing ts nodes
function visualNode()
  -- select the current node, entering visual mode
  vs[[STSSelectCurrentNode]]
  -- set the binds for navigating
  map('x', 'n', '<cmd>STSSelectPrevSiblingNode<CR>', bindopt)
  map('x', 'o', '<cmd>STSSelectNextSiblingNode<CR>', bindopt)
  map('x', 'e', '<cmd>STSSelectParentNode<CR>', bindopt)
  map('x', 'i', '<cmd>STSSelectChildNode<CR>', bindopt)
  --set the binds for editing
  map('x', 'N', '<cmd>STSwapPrevVisual<CR>', bindopt)
  map('x', 'O', '<cmd>STSwapNextVisual<CR>', bindopt)

  -- cue the binds to be removed when visual mode is left
  -- i had an autocmd but binding esc literally makes more sense
  lmap({'n','i','x','o'}, '<ESC>', function ()
      vim.keymap.del('x', 'n')
      vim.keymap.del('x', 'o')
      vim.keymap.del('x', 'e')
      vim.keymap.del('x', 'i')
      vim.keymap.del('x', 'N')
      vim.keymap.del('x', 'O')
      vim.keymap.del({'n','i','x','o'}, '<ESC>')
      -- what the fuck
      vs(vim.api.nvim_replace_termcodes('normal <ESC>', true, true, true))
    end,
    bindopt)
end

-- }}}

-- {{{ lazy config
lazyConf = {
  -- defaults = { lazy = true },
  dev = {
    path = "~/project/git/",
    patterns = { "spiderforrest"},
    fallback = true,
  },
  checker = {
    enabled = true,
    concurrency = 1,
    notify = false,
  },
  install = {
    colorscheme = { "everforest", "habamax" }
  },
}


-- vim:foldmethod=marker
