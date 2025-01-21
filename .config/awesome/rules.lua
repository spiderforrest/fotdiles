local awful = require("awful")
local beautiful = require("beautiful")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = {
      border_width = beautiful.border_width,
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
    { class = { "zoom", "Arandr", "PenTablet", },
      name = { "Event Tester", "Media viewer",  },
      role = { "pop-up", }
    },
    properties = { floating = true }
  },

  -- -- autohide
  { rule_any = {
    class = {
      --     "KeePassXC",
      --     "pavucontrol-qt",
      -- "PenTablet",
      }
    },
    properties = { hidden = true, floating = true }
  },

  -- yayyyy tennny lozzieee losognia
  { rule_any = { name = { "Tenny!!!" } },
    properties = { floating = true, sticky = true, ontop = true } -- yes, women can do that
  },

  -- console
  { rule_any =
    { class = { "local", "serv", "PenTablet" } },
    properties = { tag = tags[11] }
  },

  -- mooosic
  { rule_any =
    { name = { "ncspot" } },
    properties = { tag = tags[12] }
  },

  -- chat clients
  { rule_any =
    { class = {  "Telegram", "Gajim"  } },
    properties = { tag = tags[13] }
  },

  -- fuck you zoom
  -- see signals.lua for most of that
  { rule_any =
    { name = "Zoom Meeting"},
    properties = { floating = false }
  },

  { rule_any =
    { class = { "Zoom Meeting" } },
    properties = { tag = tags[14] }
  },
}
-- }}}

-- function awful.rules.high_priority_properties

-- vim: foldmethod=marker
