return {
    -- for testing
    -- { 'folke/which-key.nvim', config = true },
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
            endif
            ]]
          end,
    },
    { 'karoliskoncevicius/sacredforest-vim', event = 'VeryLazy' }, -- kinda softer version of my scheme
    { 'shaunsingh/oxocarbon.nvim', event = 'VeryLazy' }, -- purble :)
    -- (syntax) colorssss
    { 'uga-rosa/ccc.nvim', event = 'VeryLazy', -- color picker/highlighter
        init = function()
            local ccc = require("ccc")
            ccc.setup({ highlighter = { auto_enable = true } })
        end
    },
    { 'sheerun/vim-polyglot', event = 'VeryLazy', -- syntax highlighter metapackage
        init = function()
            g.vim_jsx_pretty_colorful_config = 1
            g.colorizer_skip_comments = 1
            g.colorizer_x11_names = 1
            g.colorizer_auto_map = 1
        end
    },
    { "Jxstxs/conceal.nvim", dependencies = "nvim-treesitter/nvim-treesitter", event = 'VeryLazy', -- fancy treesitter rerendering!
        config = function()
            conceal = require('conceal')
            conceal.setup({})
        end
    },
    { 'luochen1990/rainbow', -- color nested brackets -- consider upgrading sometime to HiPhish/nvim-ts-rainbow2
        init = function()
            vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "" })
            g.rainbow_active = 1
        end
    },
    -- indentation
    { 'nathanaelkane/vim-indent-guides', event = 'VeryLazy', -- show lines for indentation
        config = function()
            g.indent_guides_auto_colors = 0
            g.indent_guides_guide_size = 1
            g.indent_guides_enable_on_vim_startup = 1
            g.indent_guides_start_level = 2
        end
    },
    -- flat window & focus
    { 'junegunn/goyo.vim', cmd = 'Goyo' }, -- make that lil window in the middle that i like
    { 'junegunn/limelight.vim', cmd = 'Limelight' }, -- highlight current block brighter
    -- ui revamp
    { 'kyazdani42/nvim-web-devicons', event = 'VeryLazy' }, -- icons and emojis n shit: 🗿
    { 'eandrju/cellular-automaton.nvim', event = 'VeryLazy' }, -- no comment.
}
