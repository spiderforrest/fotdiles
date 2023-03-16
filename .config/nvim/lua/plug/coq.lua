return {
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
}
