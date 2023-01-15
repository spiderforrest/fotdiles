local awful = require("awful")
local beautiful = require("beautiful")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false,
     }
    },

    -- Floating clients.
    { rule_any =
        { class = {
            "zoom",
            "Arandr", },
        name = {
            "Event Tester",
            "Media viewer", },
        role = {
            "pop-up", }
        },
        properties = { floating = true }
    },

    -- -- autohide
    -- { rule_any = {
    --     class = {
    --         "KeePassXC",
    --         "pavucontrol-qt" }
    --     }, properties = { hidden = true, floating = true }
    -- },

    -- console
    { rule_any =
        { class = {
            "local",
            "serv"}
        },
        properties = { tag = tags[11] }
    },

    -- chat clients
    { rule_any =
        { class = {
            "discord",
            "Telegram",
            "Ripcord",
            "Slack" }
        },
        properties = { tag = tags[12] }
    },

    -- music
    { rule_any =
        { class = "Spotify" },
        properties = { tag = tags[13] }
    },

    -- fuck you zoom
    -- see signals for most of that
    { rule_any =
        { name = "Zoom Meeting"},
        properties = { floating = false }
    }
}
-- }}}

-- function awful.rules.high_priority_properties

-- vim: foldmethod=marker
