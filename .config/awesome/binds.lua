local gears = require("gears")
local awful = require("awful")
local sharedtags   = require("sharedtags")

-- local naughty = require("naughty")

-- {{{ Mouse bindings
root.buttons(quick_bind_button{
  { key=5, mod={}, lua=function()
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if #s.tags == s.selected_tag.index then return end
    awful.tag.viewnext(s)
  end },
  { key=4, mod={}, lua=function()
    local s = awful.screen.focused()
    if not s.selected_tag then return end
    if 1 == s.selected_tag.index then return end
    awful.tag.viewprev(s)
  end }
})
-- }}}

-- {{{ passthrough bindings

globalkeys = gears.table.join(
  globalkeys,
  -- function i wrote, check defines.lua for paramaters
  quick_bind{
    -- misc
    { mod={}, key="Print", sh="flameshot gui -r | xclip -selection clipboard -t image/png && pkill flameshot" },
    { key="]", sh="xrandr --output DisplayPort-0 --mode 2560x1440 --rate 144.00 --output HDMI-A-0 --scale 1.33x1.33 --same-as DisplayPort-0" },
    { key="[", sh="xrandr --output DisplayPort-0 --primary --mode 2560x1440 --rate 144.00 --pos 0x0 --rotate normal --scale 1x1 --output HDMI-A-0 --mode 1920x1080 --pos 2560x180 --rotate normal --scale 1x1 && awesome-client 'awesome.restart()'" },
    { key="]", mod={meta, ctrl}, sh="xset -dpms && xset s off" },
    -- volume
    { mod={}, key="XF86AudioRaiseVolume", sh="~/bin/allume set +5%" },
    { mod={}, key="XF86AudioLowerVolume", sh="~/bin/allume set -5%" },
    { mod={}, key="XF86AudioMute", sh="~/bin/allume mute" },
    { mod={}, key="XF86AudioMicMute", sh="~/bin/allume micMute" },
    { key="XF86AudioRaiseVolume", sh="~/bin/allume set +1%" },
    { key="XF86AudioLowerVolume", sh="~/bin/allume set -1%" },
    { key="XF86AudioMute", sh="~/bin/allume hardMute" },
    -- runners
    { key="q", prog="qutebrowser" },
    { key="Return", prog="wezterm start --class=Terminal" },
    { key="r", prog="j4-dmenu-desktop --term='wezterm'" },
    { key="s", mod={meta, alt}, prog="firejail --net=none spotify" },
    { key="e", mod={meta, alt}, prog="rofimoji" }
  }
)
-- }}}

-- {{{ Key bindings

globalkeys = gears.table.join(
  globalkeys,
  quick_bind{
    -- utility ig?
    { key="s", lua=clientmenu },
    { key="r", mod={meta, alt}, lua=awesome.restart },
    { key="r", mod={meta, alt, ctrl, shft}, lua=awesome.quit},
    { key="[", mod={meta, alt}, prog="betterlockscreen -l dim"},
    { key="/", lua=function()
      awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
    end },

    -- jumpy
    { key=" ", lua=function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end },
    { key="x", lua=awful.client.urgent.jumpto },

    -- neio
    { key="e", lua=function() awful.client.focus.byidx(1) end },
    { key="i", lua=function() awful.client.focus.byidx(-1) end },

    { key="e", mod={meta, shft}, lua=function() awful.client.swap.byidx(1) end },
    { key="i", mod={meta, shft}, lua=function() awful.client.swap.byidx(-1) end },

    { key="o", lua=function() awful.tag.incmwfact(0.05) end },
    { key="n", lua=function() awful.tag.incmwfact(-0.05) end },

    -- tag jumpy
    { key="m", lua=function() awful.screen.focus_relative(1) end },
    { key="m", mod={meta, alt}, lua=function()
      -- move tag to new monitor and focus it
      local target_tag = awful.screen.focused().selected_tag
      sharedtags.movetag(
        target_tag,
        awful.screen.focus_relative(1))
      -- check if the new screen is multitagging already
      if #awful.screen.focused().selected_tags > 2 then return end
      -- if not focus only the target tag
      sharedtags.jumpto(target_tag)
    end },

    -- layout
    { key="j", lua=function() awful.layout.inc(1) end },
    { key="h", lua=function() awful.layout.inc(-1) end },

    -- pulls clients back
    { key="u", lua=function ()
      local c = awful.client.restore()
      if c then -- focus it
        c:emit_signal(
          "request::activate", "key.unminimize", {raise = true}
        )
      end
    end }
  })

-- }}}

-- {{{ client bindings

clientkeys = gears.table.join(
  clientkeys,
  quick_bind{
    { key="f", lua=function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end
    },

    { key="BackSpace", lua=function (c) c:kill() end },
    { key="f", mod={meta, shft}, lua=awful.client.floating.toggle }, -- c.floating isn't a thing??
    { key="Tab", lua=function (c) c:swap(awful.client.getmaster()) end },
    { key="m", mod={meta, shft}, lua=function (c) c:move_to_screen() end },
    { key="t", lua=function (c) c.ontop = not c.ontop end },
    { key="p", lua=function (c) c.sticky = not c.sticky end },
    { key="d", lua=function (c) c.minimized = true end }
  }
)

-- mouse controls
clientbuttons = gears.table.join(
  clientbuttons,
  quick_bind_button{
    { key=1, mod={}, lua=function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
    end },

    { key=1, lua=function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
    end },

    { key=3, lua=function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
    end }
  }
)
-- }}}

-- {{{ tag bindings
-- function that handles all tag-related binds
local function bind_keys_to_tag(id, key)
  globalkeys = gears.table.join(
    globalkeys,
    quick_bind{
      -- view tag
      { key=key, lua=function ()
        local tag = tags[id]
        local s = awful.screen.focused()
        -- if in multitagging mode(& on same screen), toggle
        if #s.selected_tags > 1 and gears.table.hasitem(s.tags, tag) then
          sharedtags.viewtoggle(tag, s)
          return
        end
        -- otherwise just jump
        if tag then
          sharedtags.jumpto(tag)
        end
      end },
      -- toggle tag override, to enter multitagging/nil tag mode
      { key=key, mod={meta, alt}, lua=function ()
        local tag = tags[id]
        if tag then
          sharedtags.viewtoggle(tag, awful.screen.focused())
        end
      end },
      -- move client to tag
      { key=key, mod={meta, shft}, lua=function ()
        if client.focus then
          local tag = tags[id]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end },
      -- toggle tag for focused client
      { key=key, mod={meta, alt, shft}, lua=function ()
        if client.focus then
          local tag = tags[id]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end }
    }
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
