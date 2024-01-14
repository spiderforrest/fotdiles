local awful = require("awful")
local sharedtags   = require("sharedtags")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

-- autofocus clients
require("awful.autofocus")

-- snap mouse to center of window
-- require("awesomewm-micky")

beautiful.init(gears.filesystem.get_dir("config") .. "/themes/green/theme.lua")

-- i just like compaqt ok
meta = "Mod4"
alt = "Mod1"
ctrl = "Control"
shft = "Shift"
awful.util.shell = "sh"
terminal = os.getenv("TERMCMD") or "wezterm"
browser  = os.getenv("BROWSER") or "qutebrowser"
editor   = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor .. " "

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile.right,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
    require("milk")
}

-- use drauthius/awesome-sharetags to share tags between monitors
tags = sharedtags({
    { name = 1, layout = awful.layout.layouts[7], screen = 1},
    { name = 2, layout = awful.layout.layouts[7], screen = 1},
    { name = 3, layout = awful.layout.layouts[7], screen = 1},
    { name = 4, layout = awful.layout.layouts[7], screen = 1},
    { name = 5, layout = awful.layout.layouts[7], screen = 1},
    { name = 6, layout = awful.layout.layouts[1], screen = 2},
    { name = 7, layout = awful.layout.layouts[1], screen = 2},
    { name = 8, layout = awful.layout.layouts[1], screen = 2},
    { name = 9, layout = awful.layout.layouts[1], screen = 2},
    { name = 0, layout = awful.layout.layouts[1], screen = 2}, --10
    { name = " ", layout = awful.layout.layouts[1], screen = 2, useless_gap = 50}, --11
    -- { name = "", layout = awful.layout.layouts[1], screen = 2}, --12
    { name = "", layout = awful.layout.layouts[1], screen = 2}, --12
    { name = "", layout = awful.layout.layouts[1], screen = 2}, --13
    { name = " ", layout = awful.layout.layouts[2], screen = 1}, --14
    -- { name ="uhhhHH you shouldn't see this", screen = 99} -- hidden
})

-- helper function to compact binding keys while i wait for the git version to git its shit together
function quick_bind(keybind_tbl) -- {{{
    local localkeys = {}
    for _, t in ipairs(keybind_tbl) do
        -- combine the input with a template table
        local tbl = gears.table.crush({
            mod = { meta },
            key = nil,
            sh = nil,
            cb = nil,
            prog = nil,
            lua = function () naughty.notify{title="undefined action"} end,
            desc = '',
            grp = '',
            btn = false
        },
            t
        )

        -- debug check
        if not tbl.key then
            naughty.notify{ title="undefined hotkey", text=tostring(tbl.desc)}
            -- fuck you i love goto
            goto continue
        end

        -- form handler functions
        local exe = function() end
        -- shell with callback
        if tbl.sh and tbl.cb then exe = function () awful.spawn.easy_aysnc_with_shell(tbl.sh, tbl.cb) end
            -- just shell
        elseif tbl.sh then exe = function () awful.spawn.with_shell(tbl.sh) end
            -- launcher
        elseif tbl.prog then exe = function () awful.spawn(tbl.prog, false) end
            -- lua code
        else exe = tbl.lua
        end

        -- create and return the actual keybind
        if tbl.btn then
            -- for mouse buttons
            localkeys = gears.table.join(
                localkeys,
                awful.button(tbl.mod, tbl.key, exe)
                )
        else
            -- for keyboard keys
            localkeys = gears.table.join(
                localkeys,
                awful.key(
                    tbl.mod,
                    tbl.key,
                    exe,
                    {description = tbl.desc, group = tbl.grp}
                )
            )
        end
        ::continue::
    end
    return localkeys
end -- }}}

function quick_bind_button(tbl)
for _, t in ipairs(tbl) do
        t.btn = true
    end
    return quick_bind(tbl)
end
-- vim: foldmethod=marker
