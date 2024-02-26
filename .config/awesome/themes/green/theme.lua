-------------------------------------------------------------------------------
-- gruvbox awesome theme
-------------------------------------------------------------------------------

local awful = require("awful")
local usurface = require("utils.surface")
local dpi = require("beautiful.xresources").apply_dpi
local theme_assets = require("beautiful.theme_assets")

local theme_path = awful.util.getdir("config") .. "/themes/green/"
local theme = {}

theme.font          = "Product Sans 12"
theme.icon_theme = "gruvbox-dark-icons-gtk"

-- crop to size where wallpaper repeats itself
-- theme.wallpaper = usurface.crop(theme_path .. "../wallpapers/practicepaint_kosade_1080.png", 0, 0, 1920, 1080)
-- theme.wallpaper = usurface.crop(theme_path .. "../wallpapers/river_paintpractice.png", 384, 0, 1920, 1080)
-- theme.wallpaper = theme_path .. "../wallpapers/Ø!.png"
-- theme.wallpaper = theme_path .. "../wallpapers/dark Ø!.png"
-- theme.wallpaper = theme_path .. "../wallpapers/dark gas Ø!.png"
-- theme.wallpaper = theme_path .. "../wallpapers/dark gas snake Ø!.png"
theme.wallpaper = theme_path .. "../wallpapers/a little bit upbeat these days.png"
-- control if it's per screen or both
theme.wallpaper_global = true
-- theme.wallpaper_global = false

-- Dark Gruvbox Colors
theme.lightred    = "#fb4934"
theme.red         = "#cc241d"
theme.lightorange = "#fe8019"
theme.orange      = "#d65d0e"
theme.lightyellow = "#fabd2f"
theme.yellow      = "#d79921"
theme.lightgreen  = "#b8bb26"
theme.green       = "#98971a"
theme.lightaqua   = "#8ec07c"
theme.aqua        = "#689d6a"
theme.lightblue   = "#83a598"
theme.blue        = "#458588"
theme.lightpurple = "#d3869b"
theme.purple      = "#b16286"
theme.fg0         = "#fbf1c7"
theme.fg1         = "#ebdbb2"
theme.fg2         = "#d5c4a1"
theme.fg3         = "#bdae93"
theme.fg4         = "#a89984"
theme.gray        = "#928374"
theme.bg4         = "#7c6f64"
theme.bg3         = "#665c54"
theme.bg2         = "#504945"
theme.bg1         = "#3c3836"
theme.bg0_s       = "#32302f"
theme.bg0         = "#282828"
theme.bg0_h       = "#1d2021"

theme.brightblue  = "#50bbfc"

theme.lighter_highlight     = "#0d4c7f"
theme.darker_highlight      = "#3c660a"
theme.tertiary_highlight    = "#984674"

theme.lighter_bg            = theme.darker_highlight
theme.darker_bg             = "#243d06"
theme.tertiary_bg           = theme.bg4

theme.lighter_fg            = "#eeeeee"
theme.darker_fg             = "#051e33"
theme.tertiary_fg           = theme.fg4

-- Colors
theme.bg_normal  = theme.darker_bg
theme.bg_focus   = theme.lighter_highlight
theme.bg_urgent  = theme.bg0_h
theme.bg_systray = theme.darker_bg

theme.fg_normal  = theme.fg4
theme.fg_focus   = theme.fg1
theme.fg_urgent  = theme.lightorange

--  Borders
theme.useless_gap       = dpi(4)
theme.gap_single_client = true
theme.border_width      = dpi(2)
theme.border_normal     = "#00000000"
theme.border_focus      = theme.darker_highlight
theme.border_marked     = theme.lightpurple
theme.border_ontop      = theme.lightpurple
theme.border_sticky     = theme.yellow

-- Titlebars
theme.titlebar_bg_focus  = theme.bg0_s
theme.titlebar_fg_focus  = theme.bg0_s
theme.titlebar_fg_normal = theme.bg0_s
theme.titlebar_bg_normal = theme.bg0_s

-- Taglist
theme.taglist_fg_empty    = theme.lighter_fg
theme.taglist_fg_occupied = theme.lighter_fg
theme.taglist_fg_focus    = theme.lighter_fg
theme.taglist_fg_urgent   = theme.lighter_fg
theme.taglist_fg_volatile = theme.bg0
theme.taglist_bg_focus    = theme.tertiary_highlight
theme.taglist_bg_urgent   = theme.lightorange
theme.taglist_bg_occupied = theme.darker_highlight
theme.taglist_bg_volatile = theme.lightpurple
theme.taglist_bg_empty    = theme.lighter_highlight
theme.taglist_bg_hover    = theme.bg2
theme.taglist_font        = "Product Sans 12"
theme.taglist_shape_border_width     = dpi(1)

-- Menu
theme.menu_height       = dpi(16)
theme.menu_width        = dpi(120)
theme.menu_border_width = dpi(3)
theme.menu_fg_normal    = theme.fg1
theme.menu_bg_focus     = theme.bg2
theme.menu_border_color = theme.bg0_h

-- Menu of clients
theme.clientsmenu_width        = dpi(420)
theme.clientsmenu_border_color = theme.bg4

-- hotkeys popup
theme.hotkeys_border_color = theme.bg4

-- Menubar
theme.menubar_border_width = theme.border_width

-- Notifications
theme.notification_opacity = 0.75

-- Custom sizes
theme.small_gap        = dpi(1)
theme.gap              = dpi(2)
theme.big_gap          = dpi(7)
theme.negative_gap     = dpi(-3)
theme.big_negative_gap = dpi(-5)
theme.wibar_height     = dpi(18)
-- theme.wibar_width     = dpi(800)
theme.titlebar_height  = dpi(10)

-- Systray
theme.systray_icon_spacing = theme.gap

-- All Widgets
theme.widget_markup = "<span weight='heavy' color=%q>%s</span>"

-- Playback Status Widget
theme.playback_width     = dpi(100)
theme.playback_bg_normal = theme.bg1
theme.playback_bg_hover  = theme.bg2
theme.playback_bg_press  = theme.bg3

-- Layout
theme.layout_tile       = theme_path .. "layouts/tile.svg"
theme.layout_tileleft   = theme_path .. "layouts/tileleft.svg"
theme.layout_tilebottom = theme_path .. "layouts/tilebottom.svg"
theme.layout_tiletop    = theme_path .. "layouts/tiletop.svg"
theme.layout_fairv      = theme_path .. "layouts/fair.svg"
theme.layout_fairh      = theme_path .. "layouts/fair.svg"
theme.layout_spiral     = theme_path .. "layouts/spiral.svg"
theme.layout_dwindle    = theme_path .. "layouts/spiral.svg"
theme.layout_max        = theme_path .. "layouts/max.svg"
theme.layout_fullscreen = theme_path .. "layouts/fullscreen.svg"
theme.layout_magnifier  = theme_path .. "layouts/magnifier.svg"
theme.layout_floating   = theme_path .. "layouts/floating.svg"
theme.layout_cornernw   = theme_path .. "layouts/cornernw.svg"
theme.layout_cornerne   = theme_path .. "layouts/cornerne.svg"
theme.layout_cornersw   = theme_path .. "layouts/cornersw.svg"
theme.layout_cornerse   = theme_path .. "layouts/cornerse.svg"
theme.layout_centerwork = theme_path .. "layouts/centerwork.svg"
theme.layout_milk       = theme_path .. "layouts/milk.svg"

-- Titlebar
theme.titlebar_ontop_button_focus_active    = theme_path .. "titlebar/ontop_select.svg"
theme.titlebar_ontop_button_normal_active   = theme_path .. "titlebar/ontop_select.svg"
theme.titlebar_ontop_button_focus_inactive  = theme_path .. "titlebar/ontop_unselect.svg"
theme.titlebar_ontop_button_normal_inactive = theme_path .. "titlebar/ontop_unselect.svg"

theme.titlebar_sticky_button_focus_active    = theme_path .. "titlebar/sticky_select.svg"
theme.titlebar_sticky_button_normal_active   = theme_path .. "titlebar/sticky_select.svg"
theme.titlebar_sticky_button_focus_inactive  = theme_path .. "titlebar/sticky_unselect.svg"
theme.titlebar_sticky_button_normal_inactive = theme_path .. "titlebar/sticky_unselect.svg"

theme.titlebar_maximized_button_focus_active    = theme_path .. "titlebar/maximized_select.svg"
theme.titlebar_maximized_button_normal_active   = theme_path .. "titlebar/maximized_select.svg"
theme.titlebar_maximized_button_focus_inactive  = theme_path .. "titlebar/maximized_unselect.svg"
theme.titlebar_maximized_button_normal_inactive = theme_path .. "titlebar/maximized_unselect.svg"

theme.titlebar_floating_button_focus_active    = theme_path .. "titlebar/floating_select.svg"
theme.titlebar_floating_button_normal_active   = theme_path .. "titlebar/floating_select.svg"
theme.titlebar_floating_button_focus_inactive  = theme_path .. "titlebar/floating_unselect.svg"
theme.titlebar_floating_button_normal_inactive = theme_path .. "titlebar/floating_unselect.svg"

-- Icons
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)
theme.archlinux_icon  = theme_path .. "bar/archlinux.svg"

return theme

