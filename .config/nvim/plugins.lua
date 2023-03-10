
-- {{{ setup
-- bootstrap lazy on blank installs
if not vim.loop.fs_stat(lazypath) then
    fn.system({
        "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

-- lazy setup
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
        { 'karoliskoncevicius/sacredforest-vim', event = 'VeryLazy' }, -- kinda softer version of my scheme
        { 'shaunsingh/oxocarbon.nvim', event = 'VeryLazy' }, -- purble :)
        -- (syntax) colorssss
        'norcalli/nvim-colorizer.lua', -- highlight color codes in colors
        { 'sheerun/vim-polyglot', event = 'VeryLazy',
            init = function()
                g.vim_jsx_pretty_colorful_config = 1
                g.colorizer_skip_comments = 1
                g.colorizer_x11_names = 1
                g.colorizer_auto_map = 1
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
        { 'junegunn/goyo.vim', event = 'VeryLazy' }, -- make that lil window in the middle that i like
        { 'junegunn/limelight.vim', event = 'VeryLazy' }, -- highlight current block brighter
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
                    lualine_x = {'fileformat', line_wc},
                    lualine_y = { 'encoding', { 'filetype', icons_enabled = false } },
                    lualine_z = { 'progress', 'location', line_sym_2}
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
        { 'kyazdani42/nvim-web-devicons', event = 'VeryLazy' }, -- icons and emojis n shit: 🗿
        -- }}}

        -- {{{ coq and lsps
        -- lsp meta
        { 'neovim/nvim-lspconfig', event = 'VeryLazy' }, -- default configs for lsps
        { 'williamboman/mason.nvim', event = 'VeryLazy' }, -- lsp manager
        { 'williamboman/mason-lspconfig.nvim', event = 'VeryLazy' }, -- lsp manager integration
        -- {{{ coq
        { 'ms-jpq/coq_nvim', -- prediction
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
                    require("mason").setup()
                    require("mason-lspconfig").setup()

                    -- lsp header
                    local lsp = require("lspconfig")
                    local coq = require("coq")

                    -- lsp list, just follow the formula i am aware i could simplify this but i don't know lua so
                    lsp.html.setup{}
                    lsp.html.setup(coq.lsp_ensure_capabilities{})
                    lsp.eslint.setup{}
                    lsp.eslint.setup(coq.lsp_ensure_capabilities{})
                    lsp.cssls.setup{}
                    lsp.cssls.setup(coq.lsp_ensure_capabilities{})
                    lsp.clangd.setup{}
                    lsp.clangd.setup(coq.lsp_ensure_capabilities{})
                    lsp.rome.setup{}
                    lsp.rome.setup(coq.lsp_ensure_capabilities{})
                    lsp.bashls.setup{}
                    lsp.bashls.setup(coq.lsp_ensure_capabilities{})
                    lsp.jsonls.setup{}
                    lsp.jsonls.setup(coq.lsp_ensure_capabilities{})
                    lsp.vimls.setup{}
                    lsp.vimls.setup(coq.lsp_ensure_capabilities{})
                    --2lazy to figure out custom shit
                    --lsp.grammerly.setup{}
                    --lsp.grammerly.setup(coq.lsp_ensure_capabilities{})

                    -- custom sources for completion
                    require("coq_3p"){
                        { src = "nvimlua", short_name = "nCFL", conf_only = false },
                        -- math completion
                        { src = "bc", short_name = "MATH", precision = 6 },
                        -- lol
                        { src = "cow", trigger = "!cow" },
                        -- banner
                        { src = "figlet", short_name = "BAN", trigger = "!ban"},
                        -- shell output pipe. soo sketchy. soo great.
                        {
                            src = "repl",
                            short_name = "BASH",
                            sh = "bash",
                            max_lines = 99,
                            deadline = 500,
                            -- christ this is gonna fuck me over
                            unsafe = { "rm", "poweroff", "reboot", "mv", "cp", "rmdir" }
                        },
                    }
                end
            },
            { 'ms-jpq/coq.artifacts', branch = 'artifacts', event = 'VeryLazy' },
            { 'ms-jpq/coq.thirdparty', branch = '3p', event = 'VeryLazy' },
            -- }}}
        -- lsp/lint raw
        { 'dsznajder/vscode-es7-javascript-react-snippets', build = 'yarn install --frozen-lockfile && yarn compile' , event = 'VeryLazy' }, -- god i hate react
        -- { 'vim-syntastic/syntastic', event = 'VeryLazy' },
        { 'rust-lang/rust.vim', ft = 'rs', config = function() vs [[
            syntax enable'
            filetype plugin indent on'
            ]] end
        },
        { 'chrisbra/csv.vim', ft = 'csv' },
        'mattn/emmet-vim', -- complex tag wrapping generator-writes most my html
        -- ale
        { 'dense-analysis/ale', event = 'VeryLazy', -- big guy for handling complex lsp integration
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
        { 'ms-jpq/chadtree', branch = 'chad', build =  'python3 -m chadtree deps', event = 'VeryLazy' }, -- file manager
        { 'samodostal/image.nvim', event = 'VeryLazy' }, -- ascii image veiwer
        { 'mbbill/undotree', event = 'VeryLazy' }, -- undo manager
        { 'wakatime/vim-wakatime', event = 'VeryLazy' }, -- time tracker
        -- VIM TWO PLAYER MODE 1V1 ME NERD
        { 'jbyuki/instant.nvim', init = function() g['instant_username'] = "$HOSTNAME" end  }, -- allows remote connections to share session
        -- git
        { 'airblade/vim-gitgutter', event = 'VeryLazy' }, -- show git on left bar
        { 'tpope/vim-fugitive', event = 'VeryLazy' },
        -- quickfix
        { 'kevinhwang91/nvim-bqf', event = 'VeryLazy' }, -- redoes quickfix gui
        -- self described swiss army knife plugin
        { 'echasnovski/mini.nvim', event = 'VeryLazy', version = false, config = function ()
            require('mini.indentscope').setup{ draw = { delay = 0 }, symbol = '·' } -- dots on scope
            require('mini.cursorword').setup{ delay = 0 } -- highlight word
            require('mini.map').setup() -- chart on the right that i never fucking use
            require('mini.trailspace').setup() -- trailing whitespace
            require('mini.comment').setup{ mappings = { comment = '<leader>\\', comment_line = '<leader>\\' } } -- comment/uncomment
            require('mini.align').setup() -- align columns
            require('mini.surround').setup() -- edit wrappers like <li></li> and {}
            require('mini.jump2d').setup{ mappings = { start_jumping = '<leader> ' } } -- hinting
            -- require('mini.pairs').setup() -- auto adds the second bracket. usually annoying.
            require('mini.bracketed').setup() -- jump various scopes via square bracket keys
            require('mini.fuzzy').setup() -- fuzzy finding
        end
        },
        {
        'nvim-telescope/telescope.nvim', tag = '0.1.1', -- big fuzzy finder
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
        config = function()
            telescope = require('telescope.builtin')
        end
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
