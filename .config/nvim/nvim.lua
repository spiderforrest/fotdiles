-- Spider's vim configs! I use Lazy for plugins, coq for completion, and mini for lots of junk
-- I use a tonn more external plugins, those are just the big ones-check ./plugins.lua for all of them

-- bloated btw, I want a full IDE and writing tools, I need to get things done on a daily basis and
-- tuning my vim for hours to shave 20ms oft startup is not worth it
-- as fun as that sounds to me :(

-- calls
dofile(vim.fn.stdpath("config") .. "/defines.lua")
dofile(vim.fn.stdpath("config") .. "/plugins.lua")
dofile(vim.fn.stdpath("config") .. "/binds.lua")
dofile(vim.fn.stdpath("config") .. "/sets.lua")

