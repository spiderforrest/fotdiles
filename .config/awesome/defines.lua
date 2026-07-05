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

-- the single time in this 'config' where i 'set' a 'setting' like a normal config
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false

-- i just like compaqt ok
meta = "Mod4"
alt = "Mod1"
ctrl = "Control"
shft = "Shift"
awful.util.shell = "sh"
terminal = os.getenv("TERMCMD") or "wezterm"
-- terminal = "neovide -- -c terminal -c startinsert" -- i still do this it just breaks cli stuff thru dmenu etc
browser  = os.getenv("BROWSER") or "qutebrowser"
-- editor   = os.getenv("EDITOR") or "nvim"
editor   = "neovide"
-- editor_cmd = terminal .. " -e " .. editor .. " "


-- xrandr display config
-- the ports change if i look in the general direction of the back of the computer
-- local framerate, primary, secondary, secondary_pos = "165.00", "DisplayPort-2", "HDMI-A-0", "2560x0"
local framerate, primary, secondary, secondary_pos = "165.00", "DisplayPort-2", "DisplayPort-1", "2560x0"
-- local framerate, primary, secondary, secondary_pos = "144.00", "DisplayPort-0", "HDMI-A-0", "2560x180"

-- normal usage cmd
xrandr_cmd = "xrandr --output " .. primary .. " --primary --mode 2560x1440 --pos 0x0 --rate " .. framerate ..
    " --output " .. secondary .. " --mode 1920x1080 --pos " .. secondary_pos .. " --rotate normal --scale 1x1"
-- mirroring
xrandr_mirror_cmd = "xrandr --output " .. primary .. " --mode 2560x1440 --rate " .. framerate ..
    " --output " .. secondary .. " --scale 1.33x1.33 --same-as " .. primary

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile.right,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.floating,
    require("milk")
}
-- i do in fact kind of wish there was a deep copy shorthand
-- Q//~//Q
-- ^ idiot sad ascii courtesy of the foxxo
local layouts_milkless = {
    awful.layout.suit.tile.right,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
}

-- gets confused about screens, i can swap it here
local scr_idx = { 1, 2 }
-- use drauthius/awesome-sharetags to share tags between monitors
tags = sharedtags({
    { name = 1, layout = awful.layout.layouts[7], screen = scr_idx[1]},
    { name = 2, layout = awful.layout.layouts[7], screen = scr_idx[1]},
    { name = 3, layout = awful.layout.layouts[7], screen = scr_idx[1]},
    { name = 4, layout = awful.layout.layouts[7], screen = scr_idx[1]},
    { name = 5, layout = awful.layout.layouts[7], screen = scr_idx[1]},
    { name = 6, layout = awful.layout.layouts[1], screen = scr_idx[2]},
    { name = 7, layout = awful.layout.layouts[1], screen = scr_idx[2]},
    { name = 8, layout = awful.layout.layouts[1], screen = scr_idx[2]},
    { name = 9, layout = awful.layout.layouts[1], screen = scr_idx[2]},
    { name = 0, layout = awful.layout.layouts[1], screen = scr_idx[2]}, --10
    { name = " ", layout = awful.layout.layouts[1], screen = scr_idx[2], useless_gap = 50}, --11
    -- { name = "", layout = awful.layout.layouts[1], screen = scr_idx[2]}, --12
    { name = " 𝅘𝅥𝅮   ", layout = awful.layout.layouts[1], screen = scr_idx[2], useless_gap = 50}, --12
    { name = "", layout = awful.layout.layouts[1], screen = scr_idx[2]}, --13
    { name = " ", layout = awful.layout.layouts[2], screen = scr_idx[1]}, --14
})

-- avoid setting the milk layout on the other monitor
-- modifying the layout list doesn't seem to work?
function safe_layout_inc(inc)
    -- if not on the primary monitor, pass a modified layouts table in
    if awful.screen.focused().index > 1 then
        awful.layout.inc(inc, awful.screen.focused(), layouts_milkless)
    else
        awful.layout.inc(inc)
    end
end

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
            -- fuck you i love goto (legitimate explaination: there's no continue in lua)
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
