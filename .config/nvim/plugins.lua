-- {{{ setup
-- defines
local fn = vim.fn
local vs = vim.cmd
local set = vim.opt
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
-- bootstrap lazy on blank installs
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
set.rtp:prepend(lazypath)
-- }}}

require("lazy").setup{
  'folke/lazy.nvim',
  { 'spiderforrest/vim-colemak',
    -- flag off if Lily isn't here :(
    enabled=function()
      if fn.system({"lsusb", "|", "grep", "-c", "Lily58"}) then
        return true
      end
      return false
    end
  },
  -- {{{ file related shit
  'ms-jpq/chadtree',
  'chrisbra/csv.vim',
  -- }}}

  -- {{{ appearance
  -- theme
  'spiderforrest/everforest',
  'karoliskoncevicius/sacredforest-vim',
  { 'shaunsingh/oxocarbon.nvim', build = './install.sh' },
  -- colorssss
  'norcalli/nvim-colorizer.lua',
  'sheerun/vim-polyglot',
  -- flat window & focus
  'junegunn/goyo.vim',
  'junegunn/limelight.vim',
  -- bar
  'vim-airline/vim-airline',
  -- }}}

  -- {{{ coq and lsps
  -- lsp meta
  'neovim/nvim-lspconfig',
  'williamboman/mason-lspconfig.nvim',
  'williamboman/mason.nvim',
  -- coq
  { 'ms-jpq/coq_nvim', ['branch'] = 'coq'},
  { 'ms-jpq/coq.artifacts', ['branch'] = 'artifacts'},
  { 'ms-jpq/coq.thirdparty', ['branch'] = '3p'},
  -- lsp/lint raw
  { 'dsznajder/vscode-es7-javascript-react-snippets', build = 'yarn install --frozen-lockfile && yarn compile' },
  'vim-syntastic/syntastic',
  'rust-lang/rust.vim',
  -- ale
  'dense-analysis/ale',
  -- }}}

  -- {{{ workflow
  -- git
  'airblade/vim-gitgutter',
  'tpope/vim-fugitive',
  -- formatting
  'junegunn/vim-easy-align',
  'chrisbra/csv.vim',
  -- autocommenter
  'tpope/vim-commentary',
  -- }}}
}

-- vim:foldmethod=marker
