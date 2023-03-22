return {
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
        -- require('mini.bracketed').setup() -- jump various scopes via square bracket keys
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
}
