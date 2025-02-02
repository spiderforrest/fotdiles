local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- {{{ def functions
-- list of clients
function clientmenu()
  local clients = client.get()

  -- create the options from the list of clients
  local items = {}
  for _, c in ipairs(clients) do
    table.insert(items, {
      c.name,
      function() c:jump_to() end,
      c.icon
    })
  end

  -- pretty it
  table.sort(items, function(a, b) return a[1] < b[1] end) -- alphabetize
  items.theme = {
    width        = beautiful.clientsmenu_width,
    border_color = beautiful.clientsmenu_border_color
  }

  -- rendering
  local menu, geom = awful.menu(items), awful.screen.focused().geometry
  menu:show{
    coords = {
      x = geom.x + (geom.width - menu.width) / 2,
      y = geom.y + (geom.height - menu.height) / 2
    }
  }
end

local scroll_tag_buttons = gears.table.join(
  awful.button({ }, 5, function(t)
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if #s.tags == s.selected_tag.index then return end --prevent scrolling wrap
    awful.tag.viewnext(t.screen)
  end),
  awful.button({ }, 4, function(t)
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if 1 == s.selected_tag.index then return end --prevent scrolling wrap
    awful.tag.viewprev(t.screen)
  end)
)

local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ shft }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ meta }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  scroll_tag_buttons
)

local layoutbox_buttons = gears.table.join(
  awful.button({ }, 1, function () safe_layout_inc( 1) end),
  awful.button({ }, 3, function () safe_layout_inc(-1) end),
  awful.button({ }, 4, function () safe_layout_inc( 1) end),
  awful.button({ }, 5, function () safe_layout_inc(-1) end)
)

local no_widget_tagscrolling = gears.table.join(
  awful.button({ }, 5, function(t)
    local s = awful.screen.focused()
    if not mouse.current_widgets or #mouse.current_widgets > 1 then return end -- cancel if over actual widgets
    if not s.selected_tag then return end
    if #s.tags == s.selected_tag.index then return end
    awful.tag.viewnext(t.screen)
  end),
  awful.button({ }, 4, function(t)
    local s = awful.screen.focused()
    if not mouse.current_widgets or #mouse.current_widgets > 1 then return end
    if not s.selected_tag then return end
    if 1 == s.selected_tag.index then return end
    awful.tag.viewprev(t.screen)
  end)
)
-- }}}

-- {{{ wibar

-- this is outside because I want it shared between screens
local statusline_container = wibox.layout.fixed.horizontal()
local spacer = wibox.widget.textbox("   |  ")

-- generate everything per screen
awful.screen.connect_for_each_screen(function(s)

  -- the layout icon/scroller
  s.layout_box = awful.widget.layoutbox(s)
  s.layout_box:buttons(layoutbox_buttons)
  -- create a taglist widget
  s.taglist = awful.widget.taglist{
    screen  = s,
    -- hide tags greater than 5 if empty and nonfocused
    filter  = function (t) return (t.index < 6 or #t:clients() > 0 or t.selected) end,
    buttons = taglist_buttons -- if you assign with taglist:buttons() it sends different data??? ok
  }
  -- s.taglist:buttons(taglist_buttons)
  -- global titlebar title container
  s.title_container = wibox.container.margin()
  s.title_container:buttons(scroll_tag_buttons)
  -- global titlebar buttons contianer
  s.title_client_buttons_container = wibox.container.margin()
  s.title_client_buttons_container:buttons(scroll_tag_buttons)
  -- tray
  s.systray = wibox.widget.systray()
  s.systray.visible = false -- hide by default tho, can't mix aesthetics

  -- create the bar
  s.bar = awful.wibar{position = "top", screen = s}
  s.bar:buttons(no_widget_tagscrolling)

  -- create the layout boxes
  local bar_container = wibox.layout.align.horizontal()
  bar_container.expand = "none"

  local bar_left_container = wibox.layout.fixed.horizontal()
  local bar_right_container = wibox.layout.fixed.horizontal()

  -- imperatively populate the containers with widgets
  bar_left_container:add(s.layout_box)
  bar_left_container:add(s.taglist)
  bar_left_container:add(spacer)
  bar_left_container:add(s.systray)
  bar_right_container:add(s.title_container)
  bar_right_container:add(s.title_client_buttons_container)

  -- imperatively populate the container tree/bar
  bar_container.first = bar_left_container
  bar_container.second = statusline_container
  bar_container.third = bar_right_container
  s.bar.widget = bar_container
end) -- }}}

-- i'm soooo fancy
require("py32awe").setup{container = statusline_container, bar_command = "script -qfec 'pkill py3status ; py3status -b' -O '/dev/null'" }

-- {{{ global titlebar
local function title_create(c)
  return wibox.widget {
    markup = "<i>" .. gears.string.xml_escape(c.name or "/someone should have set this sooner/") .. "</i>",
    align = "center",
    widget = wibox.widget.textbox,
  }
end

local function title_insert(c)
  if not c.title then
    c.title = title_create(c)
  end
  c.screen.title_container.widget = c.title
  c.title_container = c.screen.title_container
end

local function title_update(c)
  if c.title then
    c.title:set_markup("<i>" .. gears.string.xml_escape(c.name or "/uh oh, not found/") .. "</i>")
  end
end

local function title_remove(c)
  -- delay unsetting of titlebar text to remove flickering on change
  gears.timer.delayed_call(function(title, container)
    if title and container and container.widget == title then
      container.widget = nil
    end
  end, c.title, c.title_container)
end

client.connect_signal("property::name", title_update)
client.connect_signal("focus", title_insert)
client.connect_signal("unfocus", title_remove)

-- }}}

-- vim: foldmethod=marker
