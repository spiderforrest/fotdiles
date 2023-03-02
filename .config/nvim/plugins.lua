
-- {{{ setup
-- i am speed
-- defines
local fn = vim.fn
local vs = vim.cmd
local set = vim.opt
local g = vim.g
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
-- this weird set of functions is just for lualine-weird syntax, can't figure out a better way to do it
local function line_sym_1()
    return '🕷'
end
local function line_sym_2()
    return '🕸️'
end
local function line_wc()
    -- print highlighted/total if in visual
    -- if vim.api.nvim_get_mode().mode == 'v' then
    --     print('hi')
    --     return tostring(fn.wordcount().visual_words) .. "/" .. tostring(fn.wordcount().words)
    -- end
    -- print cursorpos/total
    return tostring(fn.wordcount().visual_words or fn.wordcount().cursor_words) .. "/" .. tostring(fn.wordcount().words)
end
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
            set.background = 'dark'
            -- options are gelatin, cookie, cocoa, and chocolate
            g.everforest_background = 'gelatin'
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
        { 'shaunsingh/oxocarbon.nvim', event = 'VeryLazy' },
        -- (syntax) colorssss
        'norcalli/nvim-colorizer.lua',
        { 'sheerun/vim-polyglot', event = 'VeryLazy',
            init = function()
                g.vim_jsx_pretty_colorful_config = 1
                g.colorizer_skip_comments = 1
                g.colorizer_x11_names = 1
                g.colorizer_auto_map = 1
            end
        },
        { 'luochen1990/rainbow',
            init = function()
                vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "" })
                g.rainbow_active = 1
            end
        },
        -- indentation
        { 'nathanaelkane/vim-indent-guides', event = 'VeryLazy',
            init = function()
                g.indent_guides_auto_colors = 0
                g.indent_guides_guide_size = 1
                g.indent_guides_enable_on_vim_startup = 1
                g.indent_guides_start_level = 2
            end
        },
        -- flat window & focus
        { 'junegunn/goyo.vim', event = 'VeryLazy' },
        { 'junegunn/limelight.vim', event = 'VeryLazy' },
        -- {{{ bar
        { 'nvim-lualine/lualine.nvim', event = 'VeryLazy', config = function()
            require('lualine').setup {
                options = {
                    theme = 'everforest',
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                    disabled_filetypes = { statusline = { 'chadtree', 'CHADTree', 'undotree_2', 'diffpanel_3' } },
                },
                sections = {
                    lualine_a = {line_sym_1, 'mode', 'searchcount'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = { {
                        'filename',
                        symbols = {
                            modified = '+',
                            readonly = '-',
                            unnamed = '/',
                            newfile = '!'
                        },
                        -- if null, hide
                        cond = function()
                            if fn.expand('%:t') == '' then
                                return false
                            end
                            return true
                        end
                    }},
                    lualine_x = {'fileformat'},
                    lualine_y = { 'encoding', { 'filetype', icons_enabled = false, }},
                    lualine_z = { line_wc, 'progress', 'location', line_sym_2}
                },
                inactive_sections = {
                    lualine_c = {
                        {'filename',
                        -- if null, hide
                        cond = function()
                            if fn.expand('%:t') == '' then
                                return false
                            end
                            return true
                        end },
                        'filetype'},
                    lualine_x = {'location'},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            }
        end }, -- }}}
        { 'kyazdani42/nvim-web-devicons', event = 'VeryLazy' },
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
        init = function()
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
        -- { 'vim-syntastic/syntastic', event = 'VeryLazy' },
        { 'rust-lang/rust.vim', ft = 'rs', config = function() vs [[
            syntax enable'
            filetype plugin indent on'
            ]] end
        },
        { 'chrisbra/csv.vim', ft = 'csv' },
        'mattn/emmet-vim',
        -- ale
        { 'dense-analysis/ale', event = 'VeryLazy',
        init = function()
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
        { 'ms-jpq/chadtree', branch = 'chad', build =  'python3 -m chadtree deps', event = 'VeryLazy' },
        { 'mbbill/undotree', event = 'VeryLazy' },
        { 'wakatime/vim-wakatime', event = 'VeryLazy' },
        -- VIM TWO PLAYER MODE 1V1 ME NERD
        { 'jbyuki/instant.nvim', init = function() g['instant_username'] = "$HOSTNAME" end  },
        -- git
        { 'airblade/vim-gitgutter', event = 'VeryLazy' },
        { 'tpope/vim-fugitive', event = 'VeryLazy' },
        -- formatting
        { 'chrisbra/csv.vim', event = 'VeryLazy' },
        -- self described swiss army knife plugin
        { 'echasnovski/mini.nvim', event = 'VeryLazy', version = false, config = function ()
            require('mini.indentscope').setup{ draw = { delay = 0 }, symbol = '·' }
            require('mini.cursorword').setup{ delay = 0 }
            require('mini.map').setup()
            require('mini.trailspace').setup()
            require('mini.comment').setup{ mappings = { comment = '<leader>\\', comment_line = '<leader>\\' } }
            require('mini.align').setup()
            require('mini.surround').setup()
            require('mini.jump2d').setup{ mappings = { start_jumping = '<leader> ' } }
            -- require('mini.pairs').setup()
            require('mini.bracketed').setup()
            require('mini.fuzzy').setup()
        end
        },
        {
        'nvim-telescope/telescope.nvim', tag = '0.1.1', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' }
        }
        -- }}}

    }, --this looks really funny when the folds are closed lmao

    -- {{{ lazy configs
    -- configs for lazy here for whatever reason
    -- i mean i know the reason but it feels silly :3
    {
        -- defaults = { lazy = true },
        dev = {
            path = "~/project/git/",
            patterns = { "spiderforrest" },
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
)

-- }}}

-- vim:foldmethod=marker
