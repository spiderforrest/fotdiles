local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

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
-- }}}

-- {{{ py3status bar jank
    -- the actual widget should be several? or one widget.textbox
        -- several might be easier for click events. also spacing
    -- the text those want is in pango markup format
        -- which basically just xml & html objects
        -- <span foreground="green"></span> for instance does what u think it do
            -- https://docs.gtk.org/Pango/struct.Color.html
    -- parsing should be done by calling py3status with spawn.with_line_callback
        -- then errytime py3status updates it'll run the cb fn
    -- parsing itself should be done with string.gmatch
        -- the format is basically comma seperated array that holds json for each element
        -- should be able to get it into a lua metatable/array that contains everything for each element
            -- then i should be able to translate to pango
    -- click events can be handled with the lovely py3-cmd-just add a handler to pass clicks on & attach to each element

    -- OF NOTE!
        -- i should generate the handlers and such by keeping track of the elements
        -- just use the cb to update the text & check if more need to be initialized
        -- (and color)
        -- to avoid recrating handlers every half second
        -- just because this is a hobby project and i paid for the cpu cycles i'm gonna not use them

    -- the lua patterns:
        -- it looks like "{.-}" will match each object
        -- i think i just need to pull each of them out!
        -- and then parse them into a table
        -- is this gonna be uhh
            -- for obj_str in string.gfind(input, '{.-}') do
                -- parse and store obj_str
                    -- for pair_str in string.gfind(obj_str, '".-": ".-"')
                        -- the pattern should be.... '".-":' to get the key and ': ".-"' for value



-- TODO:spider figure out how to actually get them up on the bar(not sure rn because async) that handles
-- py3status just.... generating incomplete data the first few runs, probably signals with the bar

-- create the table to fill with widgets
-- i3bar_widget = {}
-- awful.spawn.with_line_callback("py3status", { stdout = function (stdout)
--   -- create the array that will be filled with the data from the json output and the iterator
--   local decoded_json_arr = {}
--   local module_itr = 0 -- lua arrays actually start at anything you want btw
--   -- iterate through all the {} pairs-each is a i3/py3 module
--   for module_str in string.gmatch(stdout, "{.-}") do
--     -- create the module's table and grab the name to use as key
--     local module_tbl = {}
--     -- pull out each key/value pair and hyuck them in the module's table
--     for key, val in string.gmatch(module_str, '"(.-)": "(.-)"') do
--        module_tbl[key] = val
--     end
--     -- append the module's table to the decoded array
--     decoded_json_arr[module_itr] = module_tbl
--     module_itr = module_itr + 1
--   end
--   -- cool! now we have converted a json string to a lua table without copy pasting from stack overflow. proud of me.
--
--   -- populate a table with generated textbox widgets
--   for i, module in ipairs(decoded_json_arr) do
--     i3bar_widget[i] = wibox.widget.textbox
--   end
--   -- now iterate through the table and either create or update the widget
-- end })
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%a, %b. %d | %H:%M.%S", 1, "-07:00")
-- gpu status
nvidia = awful.widget.watch(gears.filesystem.get_dir('config') .. "../../bin/bar.sh network", 10)
-- net
networkmanager = awful.widget.watch(gears.filesystem.get_dir('config') .. "../../bin/bar.sh nvidia", 10)
-- audio
sink_bar, sink_timer = awful.widget.watch(gears.filesystem.get_dir('config') .. "../../bin/bar.sh sink", 10)
source = awful.widget.watch(gears.filesystem.get_dir('config') .. "../../bin/bar.sh source", 10)

local taglist_buttons = gears.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ modkey }, 1, function(t)
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
  if #s.tags == s.selected_tag.index then return end
  awful.tag.viewnext(t.screen)
end),
awful.button({ }, 4, function(t)
  local s = awful.screen.focused()
  if not s.selected_tag then return end
  if 1 == s.selected_tag.index then return end
  awful.tag.viewprev(t.screen)
end)
)
local layoutbox_buttons = gears.table.join(
awful.button({ }, 1, function () awful.layout.inc( 1) end),
awful.button({ }, 3, function () awful.layout.inc(-1) end),
awful.button({ }, 4, function () awful.layout.inc( 1) end),
awful.button({ }, 5, function () awful.layout.inc(-1) end)
)


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    -- hide tags greater than 5 if empty and nonfocused
    filter  = function (t) return (t.index < 6 or #t:clients() > 0 or t.selected) end,
    buttons = taglist_buttons
  }
  --global titlebar title container
  s.title_container = wibox.container.margin()
  -- global titlebar buttons contianer
  s.buttonsbox_container = wibox.container.margin()

  -- enable scrolling tags when over this, too
  s.title_container:buttons(gears.table.join(
  awful.button({ }, 5, function(t)
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if #s.tags == s.selected_tag.index then return end
    awful.tag.viewnext(t.screen)
  end),
  awful.button({ }, 4, function(t)
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if 1 == s.selected_tag.index then return end
    awful.tag.viewprev(t.screen)
  end)
  ))
  s.buttonsbox_container:buttons(gears.table.join(
  awful.button({ }, 5, function(t)
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if #s.tags == s.selected_tag.index then return end
    awful.tag.viewnext(t.screen)
  end),
  awful.button({ }, 4, function(t)
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if 1 == s.selected_tag.index then return end
    awful.tag.viewprev(t.screen)
  end)
  ))

  -- tray
  s.systray = wibox.widget.systray()
  s.systray.visible = false

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- allow scrolling tags
  s.mywibox:buttons(gears.table.join(
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
  ))

  -- Add widgets to the wibox
  s.mywibox:setup {
    expand = "none",
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mylayoutbox,
      s.mytaglist,
    },
    { -- mids
      layout = wibox.layout.fixed.horizontal,
      s.title_container,
      s.buttonsbox_container,
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      spacing_widget = wibox.widget.textbox(" |"),
      spacing = 9,
      nvidia,
      networkmanager,
      sink_bar,
      source,
      mytextclock,
      s.systray,
    },
  }
end)
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
      c.screen.buttonsbox_container.widget = c.buttonsbox
      c.container = c.screen.buttonsbox_container
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
