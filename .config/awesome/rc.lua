local awful = require("awful")
local sharedtags = require("sharedtags")

-- {{{ Handle runtime errors
local naughty = require("naughty")
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Error!",
            text = tostring(err) })
        in_error = false
    end)
end -- }}}

dofile(awful.util.getdir("config") .. "/" .. "defines.lua")

dofile(awful.util.getdir("config") .. "/" .. "newgui.lua")

dofile(awful.util.getdir("config") .. "/" .. "binds.lua")

dofile(awful.util.getdir("config") .. "/" .. "rules.lua")

dofile(awful.util.getdir("config") .. "/" .. "signals.lua")

-- on start
awful.spawn.with_shell("~/bin/postwm.sh")
sharedtags.jumpto(tags[11]) --show terms
sharedtags.jumpto(tags[1]) -- and focus main

-- vim: foldmethod=marker
