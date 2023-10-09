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

local pwd=awful.util.getdir("config") .. "/"

dofile(pwd .. "defines.lua")

dofile(pwd .. "gui.lua")

dofile(pwd .. "binds.lua")

dofile(pwd .. "rules.lua")

dofile(pwd .. "signals.lua")

-- on start
awful.spawn.with_shell("~/bin/postwm.sh")
-- ....
awful.spawn.with_shell("~/bin/thursday_my_dudes")
sharedtags.jumpto(tags[11]) --show terms
sharedtags.jumpto(tags[1]) -- and focus main

-- vim: foldmethod=marker
