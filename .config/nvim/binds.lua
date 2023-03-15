-- call plugins {{{
map('v', '<Enter>',     ':EasyAlign<CR>', bindopt)
map('n', '<leader>f',   ':CHADopen<CR>', bindopt)
map('n', '<leader>u',   ":UndotreeToggle<CR>", bindopt)
map('n', "<leader>rs",  ":IncRename ", bindopt)
lmap('n', '<leader>tf', function() telescope.find_files() end, bindopt)
lmap('n', '<leader>tg', function() telescope.live_grep() end, bindopt)
lmap('n', '<leader>tb', function() telescope.buffers() end, bindopt)
lmap('n', '<leader>th', function() telescope.help_tags() end, bindopt)
lmap({ 'n', 'v' }, 't', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end, bindopt)
lmap('n', '<leader>w',  function() MiniMap.toggle() end, bindopt)
lmap('n', '<leader>h',  function() conceal.toggle_conceal() end, bindopt)

-- Normal Mode Swapping:
-- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
lmap("n", "gN", function() set.opfunc = "v:lua.STSSwapUpNormal_Dot" return "g@l" end, expopt)
lmap("n", "gO", function() set.opfunc = "v:lua.STSSwapDownNormal_Dot" return "g@l" end, expopt)

-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
lmap("n", "gn", function() set.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot" return "g@l" end, expopt)
lmap("n", "go", function() set.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot" return "g@l" end, expopt)

-- }}}

-- writing mode!
lmap('n', '<leader>g',   function() writing() end, bindopt)

-- nav buffers
map('n', '<leader>bn',  ':bn<CR>', bindopt)
map('n', '<leader>bp',  ':bp<CR>', bindopt)

-- terminal fixes
map('t', '<Esc>',       [[<c-\><c-n>]], bindopt)

-- {{{ external clipboard stuff
map('n', '<leader>d',   '"_d', bindopt)
map('n', '<leader>y',   '"+y', bindopt)
map('n', '<leader>Y',   '"+Y', bindopt)
map('n', '<leader>p',   '"+p', bindopt)
map('n', '<leader>P',   '"+P', bindopt)
map('v', '<leader>d',   '"_d', bindopt)
map('v', '<leader>y',   '"+y', bindopt)
map('v', '<leader>Y',   '"+Y', bindopt)
map('v', '<leader>p',   '"+p', bindopt)
map('v', '<leader>P',   '"+P', bindopt)
-- }}}

-- clear highlighting
map('n', '<leader>/',   ':noh<CR>', bindopt)

-- diffs
map('n', '<leader>tg',  ':diffget<CR>', bindopt)
map('n', '<leader>tp',  ':diffput<CR>', bindopt)
map('n', '<leader>tt',  ':diffthis<CR>', bindopt)
-- i am blind as hell
map('n', '<leader>r',   ':set invrelativenumber<CR>', bindopt)
map('n', '<leader>c',   ':set invcursorline<CR>:set invcursorcolumn<CR>', bindopt)
-- lazy wrap toggles
map('n', '<F5>',        ':set linebreak<CR>', bindopt)
map('n', '<F6>',        ':set nolinebreak<CR>', bindopt)
-- please see ToggleMouse() in defines for an explaination, my shame is immeasurable
map('n', '<leader>m',   ':call ToggleMouse()<cr>', bindopt)
-- toss open live-server in a new term
map('n', '<leader>js',  ':silent !alacritty -e "live-server" &<CR>:redraw!<CR>', bindopt)
map('n', '<leader>jn',  ':silent !alacritty -e "npm start" &<CR>:redraw!<CR>', bindopt)

-- Reload vim-colemak to remap any overridden keys
vs('silent! source "$HOME/.config/nvim/plugged/vim-colemak/plugin/colemak.vim"')

-- vim:foldmethod=marker
