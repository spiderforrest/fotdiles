local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- {{{ def functions
-- list of clients
function clientmenu(filter, selected_tags_only)
  local scr, items, clients = awful.screen.focused(), {
    theme = {
      width        = beautiful.clientsmenu_width,
      border_color = beautiful.clientsmenu_border_color
    }
  }

  if selected_tags_only then
    clients = gears.table.join(unpack(gears.table.map(function(t) return t:clients() end, scr.selected_tags)))
  else
    clients = client.get()
  end

  for c in gears.table.iterate(clients, function(c) return awful.rules.match(c, filter) end) do
  table.insert(items, {
    c.name,
    function() c:jump_to() end,
    c.icon
  })
end

table.sort(items, function(a, b) return a[1] < b[1] end)
local menu, geom = awful.menu(items), scr.geometry
menu:show{
  coords = {
    x = geom.x + (geom.width - menu.width) / 2,
    y = geom.y + (geom.height - menu.height) / 2
  }
}
end

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

local taglist_buttons = gears.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ shift }, 1, function(t)
  if client.focus then
    client.focus:move_to_tag(t)
  end
end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, function(t)
  if client.focus then
    client.focus:toggle_tag(t)
  end
end),
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

local layoutbox_buttons = gears.table.join(
awful.button({ }, 1, function () awful.layout.inc( 1) end),
awful.button({ }, 3, function () awful.layout.inc(-1) end),
awful.button({ }, 4, function () awful.layout.inc( 1) end),
awful.button({ }, 5, function () awful.layout.inc(-1) end)
)

local no_widget_tagscrolling = gears.table.join(
  awful.button({ }, 5, function(t)
    local s = awful.screen.focused()
    if #mouse.current_widgets > 1 then return end -- cancel if over actual widgets
    if not s.selected_tag then return end
    if #s.tags == s.selected_tag.index then return end
    awful.tag.viewnext(t.screen)
  end),
  awful.button({ }, 4, function(t)
    local s = awful.screen.focused()
    if #mouse.current_widgets > 1 then return end
    if not s.selected_tag then return end
    if 1 == s.selected_tag.index then return end
    awful.tag.viewprev(t.screen)
  end)
)
-- }}}

-- {{{ Wibar

-- this is outside because I want it shared between screens
local bar_right_container = wibox.layout.fixed.horizontal()

-- generate everything per screen
awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s) -- wallpaper

  -- the layout icon/scroller
  s.layout_box = awful.widget.layoutbox(s)
  -- create a taglist widget
  s.taglist = awful.widget.taglist{
    screen  = s,
    -- hide tags greater than 5 if empty and nonfocused
    filter  = function (t) return (t.index < 6 or #t:clients() > 0 or t.selected) end,
    buttons = taglist_buttons
  }
  --global titlebar title container
  s.title_container = wibox.container.margin()
  -- global titlebar buttons contianer
  s.title_client_buttons_container = wibox.container.margin()
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
  local bar_mid_container = wibox.layout.fixed.horizontal()

  -- imperatively populate the containers with widgets
  bar_left_container:add(s.layout_box)
  bar_left_container:add(s.taglist)

  bar_mid_container:add(s.title_container)
  bar_mid_container:add(s.title_client_buttons_container)
  bar_mid_container:add(s.systray)

  -- imperatively populate the container tree/bar
  bar_container.first = bar_left_container
  -- bar_container.second = bar_mid_container
  bar_container.third = bar_right_container
  s.bar.widget = bar_container
end) -- }}}

-- {{{ py3status bar jank

--[[{{{ notes
    the actual widget should be several? or one widget.textbox
          several might be easier for click events. also spacing
      the text those want is in pango markup format
          which basically just xml & html objects
          <span foreground="green"></span> for instance does what u think it do
              https://docs.gtk.org/Pango/struct.Color.html
      parsing should be done by calling py3status with spawn.with_line_callback
          then errytime py3status updates it'll run the cb fn
      parsing itself should be done with string.gmatch
          the format is basically comma seperated array that holds json for each element
          should be able to get it into a lua metatable/array that contains everything for each element
              then i should be able to translate to pango
      click events can be handled with the lovely py3-cmd-just add a handler to pass clicks on & attach to each element

      OF NOTE!
          i should generate the handlers and such by keeping track of the elements
          just use the cb to update the text & check if more need to be initialized
          (and color)
          to avoid recrating handlers every half second
          just because this is a hobby project and i paid for the cpu cycles i'm gonna not use them

      the lua patterns:
          it looks like "{.-}" will match each object
          i think i just need to pull each of them out!
          and then parse them into a table
          is this gonna be uhh
              for obj_str in string.gfind(input, '{.-}') do
                  parse and store obj_str
                      for pair_str in string.gfind(obj_str, '".-": ".-"')
                          the pattern should be.... '".-":' to get the key and ': ".-"' for value
}}}]]

-- create the table to fill with widgets
local i3bar_widgets = {}

local function add_mouse_py3_passthrough (button, target) --{{{
      return awful.button({ }, button, function ()
        awful.spawn.with_shell( "py3-cmd click --button " .. tostring(button) .. " " .. tostring(target))
      end)
end --}}}

-- create the widgets the modules repersent
local function generate_widgets(modules, box) --{{{
  -- clear out the previous set of textboxes
  for _, widget in ipairs(i3bar_widgets) do
    box:remove_widgets(widget)
  end

  -- populate a table with generated textbox widgets
  for i, module in ipairs(modules) do
    -- just create a buncha empty textboxes, we'll just mutate them later
    i3bar_widgets[i] = wibox.widget.textbox()
    -- attach buttons
    i3bar_widgets[i]:buttons(gears.table.join(
      add_mouse_py3_passthrough(1, module.name),
      add_mouse_py3_passthrough(2, module.name),
      add_mouse_py3_passthrough(3, module.name),
      add_mouse_py3_passthrough(4, module.name),
      add_mouse_py3_passthrough(5, module.name)
      ))
  end
  -- add the widgets to the box
  for _, widget in ipairs(i3bar_widgets) do
    box:add(widget)
  end
end --}}}

local function parse_json(json_str, box) --{{{
  -- create the array that will be filled with the data from the json output and the iterator
  local modules = {}
  local module_itr = 1 -- lua arrays actually start at anything you want btw
  -- track the number of modules, so if it grows, we can regenerate the widgets
  local i3_module_counter = #i3bar_widgets or 0
  -- iterate through all the {} pairs-each is a i3/py3 module
  for module_str in string.gmatch(json_str, "{.-}") do
    -- create the module's table and grab the name to use as key
    local module_tbl = {}
    -- pull out each key/value pair and hyuck them in the module's table
    for key, val in string.gmatch(module_str, '"(.-)": "(.-)"') do
       module_tbl[key] = val
    end
    -- append the module's table to the decoded array
    modules[module_itr] = module_tbl
    module_itr = module_itr + 1
  end
  -- check if there's more modules this run than the last and regenerate(or create them initally) if so
  if i3_module_counter < module_itr then
    generate_widgets(modules, box)
  end
  -- save the count for next run
  i3_module_counter = module_itr
  -- cool! now we have converted a json string to a lua table without copy pasting from stack overflow. proud of me.
  return modules
end --}}}

-- set the text inside each widget to match the i3 output
local function update_widgets(widgets, modules) --{{{
  for i, widget in ipairs(widgets) do
    local string
    if modules[i].color then
      string = '<span color="' .. modules[i].color .. '">' .. gears.string.xml_escape(modules[i].full_text) .. "</span>"
    else
      string = '<span color="white">' .. gears.string.xml_escape(modules[i].full_text) .. '</span>'
    end
    if i ~= 1 then
      string = " | " .. string
    end
    widget:set_markup_silently(string)
  end
end --}}}

-- call the statusline command and set up the callback function
local py3_pid = awful.spawn.with_line_callback("py3status", { stdout = function (stdout) --{{{
  -- call the parser
  local modules = parse_json(stdout, bar_right_container)
  update_widgets(i3bar_widgets, modules)
end })

-- while i wait for a resolution on my bug report here's hack aha
-- LGTM
awful.spawn.with_shell("cpulimit -p " .. tostring(py3_pid) .. " -l 10")

--}}}
-- }}}

    -- {{{ global titlebar
    local function title_create(c)
      return wibox.widget {
        markup = "<b>" .. (c.class or "client") .. "</b>",
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
        c.title:set_markup("<b>" .. (c.class or "client") .. "</b>")
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

    -- Update Titlbar Buttons in Wibar on focus / unfocus
    --------------------------------------------------------------------------------
    local function buttons_create(c)
      return wibox.widget {
        wibox.container.margin(awful.titlebar.widget.maximizedbutton(c), beautiful.small_gap, beautiful.small_gap),
        wibox.container.margin(awful.titlebar.widget.ontopbutton(c), beautiful.small_gap, beautiful.small_gap),
        wibox.container.margin(awful.titlebar.widget.stickybutton(c), beautiful.small_gap, beautiful.small_gap),
        layout = wibox.layout.fixed.horizontal
      }
    end

    local function buttons_insert(c)
      if not c.buttonsbox then
        c.buttonsbox = buttons_create(c)
      end
      c.screen.title_client_buttons_container.widget = c.buttonsbox
      c.container = c.screen.title_client_buttons_container
    end

    local function buttons_remove(c)
      -- delay removal for smoother transitions
      gears.timer.delayed_call(function(buttonsbox, container)
        if buttonsbox and container and container.widget == buttonsbox then
          container.widget = nil
        end
      end, c.buttonsbox, c.container)
    end

    client.connect_signal("focus", buttons_insert)
    client.connect_signal("unfocus", buttons_remove)

    -- }}}

    -- vim: foldmethod=marker
