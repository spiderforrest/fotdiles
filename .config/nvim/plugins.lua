
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
        { 'spiderforrest/vim-colemak', event = 'BufEnter', -- running it before everything else bc i'll start typing lol
        -- flag off if Lily isn't here :(
            enabled=function()
                if fn.system({"grep", "-c", "Lily58"}, fn.system('lsusb')) + 0 > 0 then -- dirty whatever
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
                vim.o.conceallevel = 2
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
        { 'eandrju/cellular-automaton.nvim', event = 'VeryLazy' }, -- no comment.
        -- }}}

        -- {{{ coq and lsps
        -- lsp meta
        -- lsp megamanger, most of these configs are copypasted, it's easier than doing it myself
        -- insert bell curve meme of 'lsp zero' 'custom lsp initializing' 'lsp zero'
        { 'VonHeikemen/lsp-zero.nvim',
            event = 'VeryLazy', -- this mf takes like a full 100ms to start up jfc
            branch = 'v1.x',
            dependencies = {
                {'neovim/nvim-lspconfig'}, -- default lsp configs
                {'williamboman/mason.nvim'}, -- lsp manager
                {'williamboman/mason-lspconfig.nvim'}, -- integration for the above
            },
            config = function()
                local lsp = require('lsp-zero').preset({
                    name = 'minimal',
                    set_lsp_keymaps = true,
                    suggest_lsp_servers = true,
                    cmp_capabilities = false, -- completions handled by coq
                })

                lsp.nvim_workspace() -- (Optional) Configure lua language server for neovim
                require("coq")
                lsp.setup()
            end
        },
        -- {{{ coq
        { 'ms-jpq/coq_nvim', -- prediction
        branch = 'coq',
        event = 'VeryLazy',
        -- must set this BEFORE loading the plugin, but the actual config function i think loads COQ iteslf, 50ms lag
        init = function() g.coq_settings = { ['auto_start'] = 'shut-up' } end,
        config = function()
        g.coq_settings = {
                ['limits.completion_manual_timeout'] = 3,
                ['display'] = {
                    ['pum.fast_close'] = false ,
                    ['ghost_text.context'] = { " ",""}  ,
                    ['pum.kind_context'] = { " 「",""}  ,
                    ['pum.source_context'] = { " | ","」"} ,
                    ['preview.border'] = 'solid',
                }
            }
            -- custom sources for completion
            require("coq_3p"){
                { src = "nvimlua", short_name = "nLu", conf_only = false },
                -- math completion
                { src = "bc", short_name = "MTH", precision = 6 },
                -- lol
                { src = "cow", trigger = "!cow" },
                -- banner
                { src = "figlet", short_name = "BAN", trigger = "!ban"},
                -- shell output pipe. soo sketchy. soo great.
                { src = "repl",
                    short_name = "SHL",
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
        -- { 'vim-syntastic/syntastic', event = 'VeryLazy' },
        { 'rust-lang/rust.vim', ft = 'rs', config = function() vs [[
            syntax enable'
            filetype plugin indent on'
            ]] end
        },
        { 'chrisbra/csv.vim', ft = 'csv' },
        { 'mattn/emmet-vim', event = 'VeryLazy' }, -- complex tag wrapping generator-writes most my html
        -- ale
        { 'dense-analysis/ale', event = 'VeryLazy', -- big guy for handling complex lsp integration
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
        { 'ms-jpq/chadtree', branch = 'chad', build =  'python3 -m chadtree deps', event = 'VeryLazy' }, -- file manager
        -- { 'edluffy/hologram.nvim', event = 'VeryLazy', config = function () require('hologram').setup{auto_display = true} end }, -- inline image rendering tanks mr wezterm
        { 'mbbill/undotree', event = 'VeryLazy' }, -- undo manager
        { 'wakatime/vim-wakatime', event = 'VeryLazy' }, -- time tracker
        -- VIM TWO PLAYER MODE 1V1 ME NERD
        { 'jbyuki/instant.nvim', event = 'VeryLazy', config = function() g['instant_username'] = "$HOSTNAME" end  }, -- allows remote connections to share session
        -- git
        { 'airblade/vim-gitgutter', event = 'VeryLazy' }, -- show git on left bar
        { 'tpope/vim-fugitive', event = 'VeryLazy' },
        -- quickfix
        { 'kevinhwang91/nvim-bqf', event = 'VeryLazy' }, -- redoes quickfix gui
        -- self described swiss army knife plugin
        { 'echasnovski/mini.nvim', event = 'VeryLazy', version = false, config = function()
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
        { "smjonas/inc-rename.nvim", config = true, event = 'VeryLazy' }, -- rename based off tree sitter
        { 'nvim-telescope/telescope.nvim', tag = '0.1.1', event = 'VeryLazy', config = true, -- big fuzzy finder
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
        },
        { 'rareitems/printer.nvim', event = 'VeryLazy', config = { keymap = "gp" } },-- makes print statements real quickly
        {'akinsho/toggleterm.nvim', version = "*", event = 'VeryLazy', -- terminal handling
            config = function() require('toggleterm').setup{
                open_mapping = [[\\]], -- open with double backslash
                terminal_mappings = true, -- close by typing \\
                insert_mappings = false, -- i sometimes actually do have to type \\
                direction = 'vertical', -- open on right by default
                size = 80, -- by default he teeny!!
            } end
        },
        { 'nvim-treesitter/playground', event = 'VeryLazy' }, -- look at the treesitter tree live
        { 'nvim-treesitter/nvim-treesitter', event = 'VeryLazy', -- explicit treesitter definition
            config = function() require('nvim-treesitter.configs').setup{
                 autotag = {
                    enable = true,
                },
                ensure_installed = {
                    "sql", "json", "json5", "javascript", "typescript", "css", "html", -- webdev
                    "bash", "rust", "lua", "c", "cpp", "make", "vim",
                    "markdown", "markdown_inline", "awk", "diff", "help", "passwd", "regex"
                },
                sync_install = false,
                auto_install = false,
                ignore_install = {},
                highlight = { enable = true, additional_vim_regex_highlighting = false },
            } end
        },
        { 'ziontee113/syntax-tree-surfer', event = 'VeryLazy', config = true } -- nav and modify based on the treesitter tree
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
