local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- auto slave
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- containment blurb
    -- if c.class == 'zoom' or c.class == 'Firefox' then
    if c.class == 'zoom' then
        -- in rules i have them all float, this unfloats the main class window
        if c.name == 'Zoom Meeting' or c.name == 'Zoom - Licensed Account' then
            c:move_to_tag(tags[14])
            c.floating = false
            return
        end
        -- zoom you pompus wet rag
        -- i don't wanna talk about it
        local id = c.window
        awful.spawn.easy_async_with_shell("xprop _NET_WM_NAME -id " .. id, function(stdio)
            naughty.notify{ title=stdio }
            -- nuke it
            if tostring(stdio) == '_NET_WM_NAME(UTF8_STRING) = "zoom"\n' then
                naughty.notify{ title="zoom suppressed", text="you're welcome." }
                c.minimized = true
                return
            elseif tostring(stdio) == '_NET_WM_NAME(UTF8_STRING) = "CrossCode Min v1.4.2-2"\n' then
                naughty.notify{ title="crosscode size intercepted" }
                c.fullscreen = true
                c:raise()
                return
            elseif tostring(stdio) == '_NET_WM_NAME(UTF8_STRING) = "MiroTalk WebRTC Video call, Chat Room & Screen Sharing. — Mozilla Firefox" \n' then
                c:move_to_tag(tags[13])
                return
            end
        end)
        -- contain the rest
        c:move_to_tag(tags[14])
    end
end)


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    if c.name == "Tenny!!!" then c.border_color = beautiful.border_normal end
end)

client.connect_signal("unfocus", function(c)
    if c.name == "Tenny!!!" then -- override for the girlies not having a border
        c.border_color = beautiful.border_normal
        return
    end
    if c.ontop then
        c.border_color = beautiful.border_ontop
    elseif c.sticky then
        c.border_color = beautiful.border_sticky
    else
        c.border_color = beautiful.border_normal
    end
end)

-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
--
-- sometime implement not needing picom to have invisible borders
-- client.connect_signal("focus", function(c)
--     -- gap single client is a bool. i don't think there's a way to put a gap around a single client?
--     c.gap_single_client = 0
--     c.border_width = beautiful.border_width
--     c.border_color = beautiful.border_focus
-- end)
-- client.connect_signal("unfocus", function(c)
--     c.gap_single_client = beautiful.border_width + beautiful.useless_gap
--     c.border_width = 0
-- end)
-- }}}


-- vim: foldmethod=marker
