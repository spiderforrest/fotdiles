-- Spider's vim configs! I use Lazy for plugins, coq for completion, and mini for lots of junk
-- I use a tonn more external plugins, those are just the big ones-check ./lua/plug/* for all of them

-- bloated btw, I want a full IDE and writing tools, I need to get things done on a daily basis and
-- tuning my vim for hours to shave 20ms of startup is not worth it
-- as fun as that sounds to me :(
-- currently it's at about 50ms i think which is neato

-- turns out my computer was shit, new puter is at 20ms lesgoo

dofile(vim.fn.stdpath("config") .. "/defines.lua")

-- bootstrap lazy on blank installs
if not vim.loop.fs_stat(lazypath) then
    fn.system({
        "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
require("lazy").setup("plug", lazyConf) -- lazy reads ./plug/*.lua and concats the returned tables

dofile(fn.stdpath("config") .. "/binds.lua")
dofile(fn.stdpath("config") .. "/sets.lua")

