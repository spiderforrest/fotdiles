-- {{{ Imports
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
-- Standard awesome library
local awful = require("awful")
local gears = require("gears")
require("awful.autofocus")
-- tags for both monitors library
local sharetags     = require("sharedtags")
-- Widget and layout library
local wibox = require("wibox")
-- low-level system libraries
local glib = require("lgi").GLib
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- other stuff
local freedesktop  = require("freedesktop")
-- i'll come back to this
-- local modalawesome = require("modalawesome")
local utils        = require("utils")
local volume       = require("widgets.volume")
local net_widget   = require("widgets.net")
local run_shell    = require("widgets.run-shell")
local unpack       = unpack or table.unpack -- luacheck: globals unpack (compatibility with Lua 5.1)
-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
  title = "Oops, there were errors during startup!",
  text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, an error happened!",
    text = tostring(err) })
    in_error = false
  end)
end

-- }}}

-- {{{ Variable definitions
-------------------------------------------------------------------------------

-- Themes define colors, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_dir("config") .. "/themes/gruvbox/theme.lua")

-- This is used later as the default terminal, browser and editor to run.
local terminal = os.getenv("TERMCMD") or "alacritty"
local browser  = os.getenv("BROWSER") or "qutebrowser"
local editor   = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor .. " "

-- Set the terminal for applications that require it.
menubar.utils.terminal = terminal

-- Default modkey.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  utils.layout.centerwork,
  awful.layout.suit.tile,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.fair,
  awful.layout.suit.spiral,
  awful.layout.suit.corner.nw,
  awful.layout.suit.max,
}

-- }}}

-- {{{ Bar
-- widgets
-- volume.init()

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Create a wibox for each screen and add it
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
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)
-- }}}

-- {{{ taglist
-- use drauthius/awesome-sharetags to share tags between monitors
local tags = sharedtags({
    { name = "1", screen = 1},
    { name = "2", screen = 1},
    { name = "3", screen = 1},
    { name = "4", screen = 1},
    { name = "5", screen = 1},
    { name = "6", screen = 2},
    { name = "7", screen = 2},
    { name = "8", screen = 2},
    { name = "9", screen = 2},
    { name = "0", screen = 2},
})
-- tag binds
for i = 1, 10 do
    globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 10,
        function ()
            local screen = awful.screen.focused()
            local tag = tags[i]
            if tag then
                sharedtags.viewonly(tag, screen)
            end
        end,
    {description = "view tag #"..i, group = "tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 10,
        function ()
            local screen = awful.screen.focused()
            local tag = tags[i]
            if tag then
                sharedtags.viewtoggle(tag, screen)
            end
        end,
    {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 10,
        function ()
            if client.focus then
                local tag = tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    {description = "move focused client to tag #"..i, group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 10,
        function ()
            if client.focus then
                local tag = tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    {description = "toggle focused client on tag #" .. i, group = "tag"})
        )
end

-- }}}

-- {{{ rules
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = {
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false,
    }
  },
}
-- }}}

-- vim: foldmethod=marker
