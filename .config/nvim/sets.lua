
-- {{{ just settings :)
set.tabstop=2
set.softtabstop=0 -- copy tabstop
set.shiftwidth=2
set.expandtab = true
set.smartindent = true
set.linebreak = true
set.showmatch = true
set.showbreak = '»'
set.fillchars = { eob = "^" }
set.smartcase = true
-- DO NOT TOUCH THIS WHY THE FUCK WAS IT SYMLINKING TO MY HOME DIRECTORY
vs('set undodir=~/.config/nvim/undodir')
set.undofile = true
set.incsearch = true
set.showmatch = true
set.confirm = true
set.ruler = true
set.scrolloff=2
--set.autochdir = true
--set.autowriteall
set.undolevels=10000 -- text is cheap
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
set.formatoptions = 'tclro12jp' -- i just wrote this and i already forgor just check :h fo-table
set.relativenumber = true

vim.o.conceallevel = 2
set.filetype = 'on'
set.syntax = 'on'

-- }}}

-- {{{ plugins
g.chadtree_settings = { ["ignore.path_glob"] = { "*srcpkgs*", "*node_modules*" } }
-- close if only chadtree left
vs[[autocmd bufenter * if (winnr("$") == 1 && &buftype == "nofile" && &filetype == "CHADTree") | q! | endif]]
-- }}}

-- {{{ neovide


if g.neovide then
  -- font = wez.font_with_fallback { -- this does not remove default fallbacks. cool.
  --     'Space Mono', -- my main font
  --     'Hurmit Nerd Font Mono', -- prettiest more compatibility font
  --     { family = 'Noto Color Emoji', assume_emoji_presentation = true },-- emoji font
  --     'Unifont', -- most complete fallback font: they have like 52k glyphts?? geebus
  -- },
  -- freetype_load_flags = 'NO_HINTING', -- no font hint
  --harfbuzz_features = { 'calt=0', 'clig=1', 'liga=0' }, -- font features, see: 
  --https://docs.microsoft.com/en-us/typography/opentype/spec/
  -- set.guifont = "Space Mono,Hurmit Nerd Font Mono,Noto Color Emoji,Unifont"
  -- set.guifont = "Space Mono:h10.4:w1"
  -- set.guifont = "DejaVu Sans Mono,Noto Color Emoji:cSYMBOL,Unifont"
  set.guifont = "Space Mono,Overpass Mono,Hurmit Nerd Font Mono,Noto Color Emoji,Unifont"
  -- set.guifont = "Monocraft:h14:w14:#e-subpixelantialias"
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

  g.neovide_scale_factor = 0.9
  local change_scale_factor = function(delta)
  end
  lmap("n", "<C-=>", function()
    g.neovide_scale_factor = g.neovide_scale_factor * 1.25
    change_scale_factor(1.25)
  end)

  lmap("n", "<C-->", function()
    g.neovide_scale_factor = g.neovide_scale_factor / 1.25
  end)

end

-- }}}

-- vim:foldmethod=marker
