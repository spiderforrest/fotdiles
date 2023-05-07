
-- call plugins {{{
map('v', '<Enter>',     '<cmd>EasyAlign<CR>', bindopt)
map('n', '<leader>f',   '<cmd>CHADopen<CR>', bindopt)
map('n', '<leader>u',   '<cmd>UndotreeToggle<CR>', bindopt)
map('n', '<leader>rs',  'IncRename ', bindopt)
lmap('n', '<leader>tf', function() telescope.find_files() end, bindopt)
lmap('n', '<leader>tg', function() telescope.live_grep() end, bindopt)
lmap('n', '<leader>tb', function() telescope.buffers() end, bindopt)
lmap('n', '<leader>th', function() telescope.help_tags() end, bindopt)
lmap({'n','v'}, 't',    function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end, bindopt)
lmap('n', '<leader>w',  function() MiniMap.toggle() end, bindopt)
lmap('n', '<leader>h',  function() conceal.toggle_conceal() end, bindopt)

-- surf a tree, i guess (i really love this one it works great with my brain)
-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
lmap('n', '<leader>o', function() set.opfunc = 'v:lua.STSSwapCurrentNodeNextNormal_Dot' return 'g@l' end, expopt)
lmap('n', '<leader>n', function() set.opfunc = 'v:lua.STSSwapCurrentNodePrevNormal_Dot' return 'g@l' end, expopt)
--Jump to next node matching list defined in defines.lua
lmap('n', 'go', function() jumpNode(true) end, bindopt)
lmap('n', 'gn', function() jumpNode(false) end, bindopt)
-- Hold a node and swap it
map('n', 'gh', '<cmd>STSSwapOrHold<CR>', bindopt)
map('v', 'gh', '<cmd>STSSwapOrHoldVisual<CR>', bindopt)
-- }}}

-- writing mode!
lmap('n', '<leader>g',   function() writing() end, bindopt)

-- nav buffers
map('n', '<leader>bn',  '<cmd>bn<CR>', bindopt)
map('n', '<leader>bp',  '<cmd>bp<CR>', bindopt)

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
map('n', '<leader>/',   '<cmd>noh<CR>', bindopt)

-- diffs
map('n', '<leader>tg',  '<cmd>diffget<CR>', bindopt)
map('n', '<leader>tp',  '<cmd>diffput<CR>', bindopt)
map('n', '<leader>tt',  '<cmd>diffthis<CR>', bindopt)
-- i am blind as hell
map('n', '<leader>r',   '<cmd>set invrelativenumber<CR>', bindopt)
map('n', '<leader>c',   '<cmd>set invcursorline<CR><cmd>set invcursorcolumn<CR>', bindopt)
-- lazy wrap toggles
map('n', '<F5>',        '<cmd>set linebreak<CR>', bindopt)
map('n', '<F6>',        '<cmd>set nolinebreak<CR>', bindopt)
-- please see ToggleMouse() in defines for an explaination, my shame is immeasurable
map('n', '<leader>m',   '<cmd>call ToggleMouse()<cr>', bindopt)
-- toss open live-server in a new term
map('n', '<leader>js',  '<cmd>silent !alacritty -e "live-server" &<CR><cmd>redraw!<CR>', bindopt)
map('n', '<leader>jn',  '<cmd>silent !alacritty -e "npm start" &<CR><cmd>redraw!<CR>', bindopt)

-- vim:foldmethod=marker
