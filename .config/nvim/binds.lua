
-- call plugins {{{
map('n', '<leader>f',   '<cmd>CHADopen<cr>', bindopt)
map('n', '<leader>u',   '<cmd>UndotreeToggle<cr>', bindopt)
map('n', '<leader>g',   '<cmd>ZenMode<cr>', bindopt)
map('n', 'gG',          '<cmd>vert Git<cr>', bindopt) -- fugative
map('n', '<leader>rs',  ':IncRename ', {noremap=true})
-- i didn't fucking use telescope
-- lmap('n', '<leader>tf', function() telescope.find_files() end, bindopt)
-- lmap('n', '<leader>tg', function() telescope.live_grep() end, bindopt)
-- lmap('n', '<leader>tb', function() telescope.buffers() end, bindopt)
-- lmap('n', '<leader>th', function() telescope.help_tags() end, bindopt)
---@diagnostic disable: undefined-global
lmap('n', '<leader>wm', function() MiniMap.toggle() end, bindopt)
lmap('n', '<leader>h', function() require"conceal".toggle_conceal() end, bindopt)
lmap('n', '<leader>ws', function() MiniTrailspace.trim() end, bindopt)
---@diagnostic enable: undefined-global

-- surf a tree, i guess (i really love this one it works great with my brain)
-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
lmap('n', '<leader>o', function() set.opfunc = 'v:lua.STSSwapCurrentNodeNextNormal_Dot' return 'g@l' end, expopt)
lmap('n', '<leader>n', function() set.opfunc = 'v:lua.STSSwapCurrentNodePrevNormal_Dot' return 'g@l' end, expopt)
--Jump to next node matching list defined in defines.lua
lmap('n', 'go', function() jumpNode(true) end, bindopt)
lmap('n', 'gn', function() jumpNode(false) end, bindopt)
-- jump into visual around a node
-- map("n", "ge", '<cmd>STSSelectCurrentNode<cr>', bindopt)
-- Hold a node and swap it
map('n', 'gh', '<cmd>STSSwapOrHold<cr>', bindopt)
map('v', 'gh', '<cmd>STSSwapOrHoldVisual<cr>', bindopt)

-- toggle lsp overlay
lmap("n", "<leader>l", function() require("lsp_lines").toggle() end, bindopt)

-- direct lsp calls (sorta)
lmap("n", "<leader> ", vim.lsp.buf.hover, bindopt)
map("n", "<leader>t", '<cmd>tag <cword><cr>', bindopt)
map("n", "<leader>T", '<cmd>tag!<cr>', bindopt)
-- }}}


-- nav buffers
map('n', '<leader>bn',  '<cmd>bn<cr>', bindopt)
map('n', '<leader>bp',  '<cmd>bp<cr>', bindopt)

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
map('n', '<leader>/',   '<cmd>noh<cr>', bindopt)

-- diffs
map('n', '<leader>tg',  '<cmd>diffget<cr>', bindopt)
map('n', '<leader>tp',  '<cmd>diffput<cr>', bindopt)
map('n', '<leader>tt',  '<cmd>diffthis<cr>', bindopt)
-- i am blind as hell
map('n', '<leader>r',   '<cmd>set invrelativenumber<cr>', bindopt)
map('n', '<leader>c',   '<cmd>set invcursorline<cr><cmd>set invcursorcolumn<cr>', bindopt)
-- please see ToggleMouse() in defines for an explaination, my shame is immeasurable
map('n', '<leader>m',   '<cmd>call ToggleMouse()<cr>', bindopt)
-- fix json, requires external dep jq
map('n', '<leader>js',  '<cmd>silent %!jq .<cr>', bindopt)

-- vim:foldmethod=marker
