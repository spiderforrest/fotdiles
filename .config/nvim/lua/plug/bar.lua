 return {
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
    end },
    { 'kyazdani42/nvim-web-devicons', event = 'VeryLazy' }, -- icons and emojis n shit: 🗿
}
