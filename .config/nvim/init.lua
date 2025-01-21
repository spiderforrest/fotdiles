-- Spider's vim configs! I use Lazy for plugins, coq for completion, treesitter for treesitter,
-- lsp-zero & mason for LSPs, Mini for random things, lualine for the bar, fork of everforest for theme
-- I use a tonn more external plugins than that, check ./lua/plug/* for all of them and their configs
-- 20ms start time on my new computer
-- 500x faster than a certain internet browser masquerading as a text editor but no shade or anything

package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua;" -- add this config dir for require
require "defines" -- defines global variables (shh) for use in the other config files
require "binds" -- creates key mappings
require "sets" -- sets config options

-- bootstrap lazy on blank installs
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end

require("lazy").setup("plug", lazyConf) -- lazy reads .lua/plug/*.lua and manages all the plugins within
