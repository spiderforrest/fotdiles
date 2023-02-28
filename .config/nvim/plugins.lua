-- {{{ setup
-- i am speed
-- defines
local fn = vim.fn
local vs = vim.cmd
local set = vim.opt
local g = vim.g
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

-- {{{ lazy setup
require("lazy").setup(
  {
    -- manage self
    'folke/lazy.nvim',
    -- keymap
    { 'spiderforrest/vim-colemak',
      -- flag off if Lily isn't here :(
      enabled=function()
        if fn.system({"lsusb", "|", "grep", "-c", "Lily58"}) then
          return true
        end
        return false
      end
    },
-- }}}

    -- {{{ appearance
    -- themes
    { 'spiderforrest/everforest',
      lazy = false,
      priority = 1000,
      config = function()
        -- options are light, dark, and null
        set.background='dark'
        -- options are gelatin, cookie, cocoa, and chocolate
        g.everforest_background = 'gelatin'
        g.airline_theme = 'everforest'
        -- apply theme and do color corrections
        vs [[
          colorscheme everforest
          if exists('+termguicolors')
            set termguicolors
            lua require('colorizer').setup()
          endif
        ]]
      end,
    },
    { 'karoliskoncevicius/sacredforest-vim', event = 'VeryLazy' },
    { 'shaunsingh/oxocarbon.nvim', build = './install.sh' },
    -- (syntax) colorssss
    'norcalli/nvim-colorizer.lua',
    { 'sheerun/vim-polyglot', event = 'VeryLazy',
      config = function()
        g.vim_jsx_pretty_colorful_config = 1
        g.colorizer_skip_comments = 1
        g.colorizer_x11_names = 1
        g.colorizer_auto_map = 1
      end
    },
    { 'luochen1990/rainbow',
      config = function()
        vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "" })
        g.rainbow_active = 1
      end
    },
    -- indentation
    { 'nathanaelkane/vim-indent-guides',
      config = function()
        g.indent_guides_auto_colors = 0
        g.indent_guides_guide_size = 1
        g.indent_guides_enable_on_vim_startup = 1
        g.indent_guides_start_level = 2
      end
    },
    {'ntpeters/vim-better-whitespace', config = function() g.better_whitespace_ctermcolor=8 end },
    -- flat window & focus
    { 'junegunn/goyo.vim', event = 'VeryLazy' },
    { 'junegunn/limelight.vim', event = 'VeryLazy' },
    -- bar
    'vim-airline/vim-airline',
    -- }}}

    -- {{{ coq and lsps
    -- lsp meta
    { 'neovim/nvim-lspconfig', event = 'VeryLazy' },
    { 'williamboman/mason-lspconfig.nvim', event = 'VeryLazy' },
    { 'williamboman/mason.nvim', event = 'VeryLazy' },
    -- coq
    { 'ms-jpq/coq_nvim',
      branch = 'coq',
      event = 'VeryLazy',
      config = function()
        vs [[ let g:coq_settings = {
            \'auto_start': 'shut-up' ,
            \'limits.completion_manual_timeout': 3,
            \'display': {
                \'pum.fast_close': v:false ,
                \'ghost_text.context': [" ",""] ,
                \'pum.kind_context': [" 「",""] ,
                \'pum.source_context': [" | ","」"],
                \'preview.border': 'solid',
            \}
        \} ]]
      end
    },
    { 'ms-jpq/coq.artifacts', branch = 'artifacts', event = 'VeryLazy' },
    { 'ms-jpq/coq.thirdparty', branch = '3p', event = 'VeryLazy' },
    -- lsp/lint raw
    { 'dsznajder/vscode-es7-javascript-react-snippets', build = 'yarn install --frozen-lockfile && yarn compile' , event = 'VeryLazy' },
    { 'vim-syntastic/syntastic', event = 'VeryLazy' },
    { 'rust-lang/rust.vim', event = 'VeryLazy' },
    { 'chrisbra/csv.vim', event = 'VeryLazy' },
    -- ale
    { 'dense-analysis/ale', event = 'VeryLazy',
      config = function()
        g.ale_fixers = {
           ['javascript'] = 'prettier',
           ['css'] = 'prettier',
           ['html'] = 'prettier',
        }
        g.ale_fix_on_save = 1
        g['airline#extensions#ale#enabled'] = 1
      end
    },
    -- }}}

    -- {{{ workflow
    { 'ms-jpq/chadtree', event = 'VeryLazy' },
    -- git
    'airblade/vim-gitgutter',
    'tpope/vim-fugitive',
    -- formatting
    { 'junegunn/vim-easy-align', event = 'VeryLazy' },
    { 'chrisbra/csv.vim', event = 'VeryLazy' },
    -- autocommenter
    { 'tpope/vim-commentary', event = 'VeryLazy' },
    -- }}}

  }, --this looks really funny when the folds are closed lmao

-- {{{ lazy configs
  -- configs for lazy here for whatever reason
  -- i mean i know the reason but it feels silly :3
  {
    defaults = { lazy = true },
    dev = {
      path = "~/project/git/",
      patterns = { "spiderforrest" },
      fallback = true,
    },
  }
)

-- }}}

-- vim:foldmethod=marker
