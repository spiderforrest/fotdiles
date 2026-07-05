
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
  -- set.linespace=-12
  g.neovide_hide_mouse_when_typing = true
  g.neovide_remember_window_size = false
  g.neovide_fullscreen = false
  g.neovide_cursor_smooth_blink = true
  g.neovide_cursor_animation_length = 0.08
  g.neovide_cursor_trail_size = 0.2
  g.neovide_cursor_vfx_particle_curl = 0.6
  g.neovide_cursor_vfx_particle_density = 4
  g.neovide_cursor_vfx_particle_lifetime = 3
  g.neovide_cursor_vfx_opacity = 200
  -- g.neovide_cursor_vfx_mode = "railgun"
  g.neovide_cursor_vfx_mode = "pixiedust"
  -- g.neovide_cursor_vfx_mode = "ripple"

  g.neovide_scale_factor = 1
  lmap("n", "<C-=>", function()
    g.neovide_scale_factor = g.neovide_scale_factor * 1.1
  end)

  lmap("n", "<C-->", function()
    g.neovide_scale_factor = g.neovide_scale_factor / 1.1
  end)


  local anim_setting_store = {
    neovide_position_animation_length = 0,
    neovide_cursor_animation_length = 0.00,
    neovide_cursor_trail_size = 0,
    neovide_cursor_animate_in_insert_mode = false,
    neovide_cursor_animate_command_line = false,
    neovide_scroll_animation_far_lines = 0,
    neovide_scroll_animation_length = 0.00
  }
  local function neovide_tg_animations()
    local tmp = {}
    for k,v in pairs(anim_setting_store) do
      tmp[k] = g[k] -- cache the prev value
      g[k] = v -- set the new value
    end
    anim_setting_store = tmp -- store the set of prev values
  end
  lmap('n', '<leader>a', neovide_tg_animations)
end

-- }}}

-- vim:foldmethod=marker
