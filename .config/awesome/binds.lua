local gears = require("gears")
local awful = require("awful")
local sharedtags   = require("sharedtags")
local hotkeys_popup = require("awful.hotkeys_popup")

local naughty = require("naughty")
-- {{{ Mouse bindings
root.buttons(gears.table.join(
awful.button({ }, 5, function()
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if #s.tags == s.selected_tag.index then return end
    awful.tag.viewnext(s)
end),
awful.button({ }, 4, function()
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if 1 == s.selected_tag.index then return end
    awful.tag.viewprev(s)
end)
))
-- }}}

-- {{{ passthrough bindings


globalkeys = gears.table.join(
globalkeys,
-- function i wrote, check defines.lua for paramaters
quick_bind{
    -- misc
    { desc="take a screenshot", mod={}, key="Print",
    sh="flameshot gui -r | xclip -selection clipboard -t image/png && pkill flameshot" },
    { desc="mirror screens", key="]",
    sh="xrandr --output DVI-D-0 --pos 0x0" },
    { desc="seperate screens", key="[",
    sh="xrandr --output DVI-D-0 --pos 1920x0 && awesome-client 'awesome.restart()'" },
    { desc="disable screensaver", key="]", mod={meta, ctrl},
    sh="xset -dpms && xset s off" },

    -- volume
    { desc="increase volume 5%", mod={}, key="XF86AudioRaiseVolume",
    sh="~/bin/allume set +5%",
    cb=function() sink_timer:again() end
},
{ desc="decrease volume 5%", mod={}, key="XF86AudioLowerVolume", sh="~/bin/allume set -5%", },
{ desc="toggle mute", mod={}, key="XF86AudioMute", sh="~/bin/allume mute", },
{ desc="toggle mic mute", mod={}, key="XF86AudioMicMute", sh="~/bin/allume micMute", },
{ desc="increase volume 1%", key="XF86AudioRaiseVolume", sh="~/bin/allume set +1%", },
{ desc="decrease volume 1%", key="XF86AudioLowerVolume", sh="~/bin/allume set -1%", },
{ desc="mute all sink/sources, set volume to 0", key="XF86AudioMute", sh="~/bin/allume hardMute", },
    }
    )

    -- }}}

    -- {{{ Key bindings

    globalkeys = gears.table.join(
    globalkeys,
    quick_bind{
        -- professional solution to the help menu being broken: comment it out
        { desc="open help", key="h", mod={meta, alt}, grp="awe", lua= function() hotkeys_popup.show_help() end },
        { desc="show all clients", key="s", grp="awe", lua=function() clientmenu{focusable = true} end },
        { desc="toggle systray", key="/", grp="awe", lua=function() awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible end },
        { desc="refresh awesome", key="r", mod={meta, alt}, lua=awesome.restart, grp="awe"},
        { desc="quit xorg", key="r", mod={meta, alt, ctrl, shft}, lua=awesome.quit, grp="awe"},
        { desc="lock screen", key="[", mod={meta, alt}, prog="betterlockscreen -l dim"},

        { desc="jump to urgent client", key="x", grp="client", lua=function() awful.client.urgent.jumpto() end },

        --nav
        { desc="go to last client", key=" ", grp="client",
        lua=function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end},
        -- { key="Return", desc="go to last tag", grp="tag", lua=function() awful.tag.history.restore() end},
        { desc="next client in stack", key="e", lua=function() awful.client.focus.byidx(1) end, grp="client" },
        { desc="previous client in stack", key="i", lua=function() awful.client.focus.byidx(-1) end, grp="client" },
        { desc="swap with next client in stack", key="e", mod={meta, shft}, lua=function() awful.client.swap.byidx(1) end, grp="client" },
        { desc="swap with previous client in stack", key="i", mod={meta, shft}, lua=function() awful.client.swap.byidx(-1) end, grp="client" },

        { desc="grow master", key="o", lua=function() awful.tag.incmwfact(0.05) end, grp="client" },
        { desc="shrink master", key="n", lua=function() awful.tag.incmwfact(-0.05) end, grp="client" },

        { desc="cycle screen focus", key="m", lua=function() awful.screen.focus_relative(1) end, grp="nav" },
        { desc="cycle tag across screens", key="m", mod={meta, alt}, grp="nav",
        lua=function()
            -- move tag to new monitor and focus it
            local target_tag = awful.screen.focused().selected_tag
            sharedtags.movetag(
            target_tag,
            awful.screen.focus_relative(1))
            -- check if the new screen is multitagging already
            if #awful.screen.focused().selected_tags > 2 then return end
            -- if not focus only the target tag
            sharedtags.jumpto(target_tag)
        end
    },

    -- runners
    { desc="qutebrowser", key="q", prog="qutebrowser", grp="run" },
    { desc="Term", key="Return", prog="wezterm", grp="run" },
    { desc="dmenu", key="r", prog="j4-dmenu-desktop --term='wezterm'", grp="run" },
    { desc="no network spotify", key="s", mod={meta, alt}, prog="firejail --net=none spotify", grp="run" },
    { desc="emoji picker", key="e", mod={meta, alt}, prog="rofimoji", grp="run" },


    { desc="cycle layout forward", key="j", lua=function() awful.layout.inc(1) end},
    { desc="cycle layout forward", key="h", lua=function() awful.layout.inc(-1) end},

    { desc="restore minimized client", key="u", grp="client",
    lua=function ()
        local c = awful.client.restore()
        if c then -- focus it
            c:emit_signal(
            "request::activate", "key.unminimize", {raise = true}
            )
        end
    end}})

    -- }}}

    --- {{{ client bindings

    -- mouse controls
    clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ meta }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ meta }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
    )
    clientkeys = gears.table.join(
    -- fuck you
    awful.key({meta}, "f", function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end,
    { description = "fullscreen client", group="client" }),


    awful.key({ meta,           }, "BackSpace", function (c) c:kill()                         end,
    {description = "close", group = "client"}),
    awful.key({ meta, shft},       "f",  awful.client.floating.toggle                     ,
    {description = "toggle floating", group = "client"}),
    awful.key({ meta            }, "Tab", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
    awful.key({ meta, shft      }, "m",      function (c) c:move_to_screen()               end,
    {description = "toggle screen", group = "client"}),
    -- awful.key({ meta,           }, "t",      function (c) c.ontop = not c.ontop            end,
    -- {description = "toggle keep on top", group = "client"}),
    awful.key({ meta,           }, "d",
    function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end ,
    {description = "minimize", group = "client"})
    -- awful.key({ meta, "Control" }, "m",
    -- function (c)
    --     c.maximized_vertical = not c.maximized_vertical
    --     c:raise()
    -- end ,
    -- {description = "(un)maximize vertically", group = "client"}),
    -- awful.key({ meta, "Shift"   }, "m",
    -- function (c)
    --     c.maximized_horizontal = not c.maximized_horizontal
    --     c:raise()
    -- end ,
    -- {description = "(un)maximize horizontally", group = "client"})
    )

    -- }}}

    -- {{{ tag bindings
    -- function that handles all tag-related binds
    local function bind_keys_to_tag(id, key)
        globalkeys = gears.table.join(
        globalkeys,
        -- view tag
        awful.key({ meta }, key,
        function ()
            local tag = tags[id]
            local s = awful.screen.focused()
            -- if currently focused on the tag or in multitagging mode(& on same screen), toggle
            if gears.table.hasitem(s.selected_tags, tag) or (#s.selected_tags > 1 and gears.table.hasitem(s.tags, tag)) then
                sharedtags.viewtoggle(tag, s)
                return
            end
            -- otherwise just jump
            if tag then
                sharedtags.jumpto(tag)
            end
        end,
        {description = "view tag #"..id, group = "tag"}),
        -- toggle tag
        awful.key({ meta, alt }, key,
        function ()
            local tag = tags[id]
            if tag then
                sharedtags.viewtoggle(tag, awful.screen.focused())
            end
        end,
        {description = "toggle tag #" .. id, group = "tag"}),
        -- move client to tag
        awful.key({ meta, shft }, key,
        function ()
            if client.focus then
                local tag = tags[id]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
        {description = "move focused client to tag #".. id, group = "tag"}),
        -- toggle tag for focused client
        awful.key({ meta, alt, shft }, key,
        function ()
            if client.focus then
                local tag = tags[id]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
        {description = "toggle focused client on tag #" .. id, group = "tag"})
        )
    end
    -- apply the tag binds
    for i= 1,9 do
        bind_keys_to_tag(i,i)
    end
    bind_keys_to_tag(10,0)
    bind_keys_to_tag(11,"`")
    bind_keys_to_tag(12,"-")
    bind_keys_to_tag(13,"'")
    bind_keys_to_tag(14,"=")

    -- Set keys
    root.keys(globalkeys)
    -- }}}

    -- vim: foldmethod=marker
