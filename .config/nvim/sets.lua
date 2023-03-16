
-- {{{ theme
-- options are light, dark, and null
set.background='dark'
-- options are gelatin, cookie, cocoa, and chocolate
g.everforest_background = 'gelatin'
g.airline_theme = 'everforest'

-- }}}


-- {{{ just settings :)
set.shiftwidth=4
set.tabstop=4
set.softtabstop=4
set.scrolloff=2
set.shiftwidth=4
set.expandtab = true
set.smartindent = true
set.linebreak = true
set.showmatch = true
set.showbreak = '»'
set.smartcase = true
-- DO NOT TOUCH THIS WHY THE FUCK WAS IT SYMLINKING TO MY HOME DIRECTORY
vs('set undodir=~/.config/nvim/undodir')
set.undofile = true
set.incsearch = true
set.showmatch = true
set.confirm = true
set.ruler = true
set.autochdir = true
--set.autowriteall
set.undolevels=1000
set.backspace='indent,eol,start'
set.ignorecase = true
set.smartcase = true
set.history=10000
set.wrap = false
set.virtualedit = 'all'
set.splitright = true
set.splitbelow = true
set.splitkeep = 'screen'
set.textwidth=135
set.number = true
set.formatoptions = 'tclro12jpaw' -- i just wrote this and i already forgor just check :h fo-table
-- set.relativenumber = true --gotta turn u off for teaching :(

-- }}}


-- {{{ neovide
set.guifont = { "Space Mono", "h6" }
set.linespace=2
g.neovide_hide_mouse_when_typing = true
g.neovide_remember_window_size = false
g.neovide_fullscreen = false
g.neovide_cursor_animation_length = 0.08
g.neovide_cursor_trail_size = 0.2
g.neovide_cursor_vfx_particle_curl = 0.6
g.neovide_cursor_vfx_particle_density = 14
g.neovide_cursor_vfx_particle_lifetime = 3
g.neovide_cursor_vfx_opacity = 200
-- g.neovide_cursor_vfx_mode = "railgun"
g.neovide_cursor_vfx_mode = "pixiedust"
-- g.neovide_cursor_vfx_mode = "ripple"

-- }}}

-- vim:foldmethod=marker
