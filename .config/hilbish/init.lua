local lunacolors = require 'lunacolors'
local bait = require 'bait'
local ansikit = require 'ansikit'
local commander = require'commander'

-- bashrc handles modifying path, env, and conditially redirecting to hilbish

hilbish.opts = {
  greeting=false,
  history=true
}

-- {{{ PS1
local function doPrompt(exit_status)
  local color_fmt
  if exit_status == 0 then
    color_fmt = '{green}'
  elseif exit_status == 1 then
    color_fmt = '{red}'
  elseif exit_status > 1 then
    color_fmt = '{yellow}'
  else
    color_fmt = '{blue}'
  end

  local stratstring = ""
  if os.getenv"BEDROCK_RESTRICT" == "1" then
    stratstring = "{yellow}(Restricted!) "
  end

  hilbish.prompt(lunacolors.format(
    stratstring .. '{green}%h {reset}@ {cyan}%d ' .. color_fmt .. '∆ ')
  )
end
-- }}}

-- {{{ greeter
bait.catch('hilbish.init', function()
  if hilbish.interactive then
    -- io.write doesn't work here...? and hilbish's echo doesn't take args...? and print() forces newlines
    hilbish.run('bash -c "echo -n ' .. lunacolors.blue() .. '"')
    hilbish.run("hilbish -v | head -n 1")
    hilbish.run('bash -c "echo -n ' .. lunacolors.blue() .. [['From ' "]]) -- thank god for lua bracket quotes...
    hilbish.run('brl which /') -- shows what stratum the binary is from by checking where it prefers to search

    local whoarewe = math.random() -- isn't it fun?
    local w = string.sub(tostring(whoarewe), 1, 5)
    local elog = function (str) print(lunacolors.format('{green}' ..  w .. ': ' .. str)) end -- to draw a little more

    if 0+w >= 0.95 then elog"{yellow}isn't there something you're supposed to be doing...?"  -- and make a little light
    elseif 0+w >= 0.8 then elog"{magenta} sparkle on!" -- to keep us happy in the night
    elseif 0+w >= 0.7 then elog"{reset} welcome, welcome" -- and aren't we made of something special?
    elseif 0+w >= 0.2 then elog"{magenta}<3 {yellow} <3 {green} <3" --that we can just create?
    elseif whoarewe > 0.001 then elog"{blue}blue{magenta}pink{brightWhite}white{magenta}pink{blue}blue" -- something to spark joy
    elseif 0+w > 0.1 and (1000 * w) % 111 == 0 then elog'{cyan}{brightMagentaBg}trips!!'
    else print(lunacolors.format("{brightRed}LIFE IS A LOT LESS THAN ONE IN A THOUSAND!! GO OUTSIDE RIGHT NOW!!!!! DO SOMETHING DUMB! PROOF: {green}" .. whoarewe .. " {blue}alsoiloveyou"))
    end
  end
end)
-- }}}

-- {{{ signals
-- set window title when running cmd
bait.catch('command.preexec', function (_, cmd)
  local stripped = string.gsub(cmd, "'", "") -- it's making a raw string to feed bash, so lightly sanitize....
  stripped = string.gsub(stripped, '"', "")
  if #stripped > 50 then stripped = string.sub(stripped, 1, 70) .. "..." end
  hilbish.run([[bash -c 'echo -ne "\033]2;$TERM - hilbish - ]] .. stripped .. [[\007"']]) -- i'm starting to see why arcan made cat9.......
end)

-- need to reset prompt to update exit code after each cmd
bait.catch('command.exit', function (code) doPrompt(code) end)
-- }}}

-- {{{ aliasi
local function alias(tbl)
  for name, command in pairs(tbl) do
    -- first register a null command on the name because completions don't add aliases
    commander.register(name, function() end)
    hilbish.alias(name, command)
  end
end
alias{
  -- shorthands
  v='nvim',
  vw='nvim "+lua writing()"', -- it feels real good changing that to a lua funtion call oooooooo
  suv='sudoedit',
  dns='ping 1.1.1.1',
  -- hm. ls builtin doesn't match bash exactly, don't think there's docs..? i have `uh` so whatev
  -- la=[[ls -Bbp1 -gah --group-directories-first --time-style=+%b\ %d --color=auto --hyperlink=auto]],
  -- ls='ls -BNp1 --group-directories-first --color=auto --hyperlink=auto',
  binfix='chmod +x ~/bin/*',
  serv='ssh spider@spood.org -p 7373',
  fserv='sftp -P 773 spider@spood.org',
  nile="cd $HOME/project/git/nile && starch ./bin/nile",
  prosody="TERM=xterm ssh -J spood.org:773 admin@xmpp.spood.org -i .aws/spider.pem",
  mine="__GL_THREADED_OPTIMIZATIONS=0 multimc -l 'the final gay'",
  vpn="mullvad status && mullvad account get | grep -v account && mullvad auto-connect get && mullvad lan get && mullvad lockdown-mode get",
  voidpkg="xpkg |  fzf --preview 'xbps-query -S {}' --layout=reverse --bind 'enter:execute(xbps-query -S {} | less)'",
  archpkg="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'",
  now="date +%s",
  printer="sudo mount UUID=84E8-2219 /mnt/other && cp /mnt/other/print_log.txt ~/printer/gcode/ ; sudo rm /mnt/other/* && sudo cp ~/printer/gcode/*.gcode /mnt/other && ls /mnt/other && sudo umount /mnt/other",
  yownload="yt-dlp --yes-playlist --no-overwrite --embed-thumbnail --embed-metadata -x -f bestaudio -o '$HOME/media/music/yownload/%(uploader)s/%(title)s.%(ext)s' --",

  -- fixes/improvements
  sl='sl -la',
  rr='rm -rI',
  dfix='dbus-run-session',
  reflector_i_barely_know_er="sudo strat -r arch reflector --save /etc/pacman.d/mirrorlist --country 'United States' --protocol https --latest 10",
  nmtui='sudo nmtui',
  shutdown='sudo shutdown',
  reboot='sudo reboot',


  -- bedrock
  stvoidm='strat -r void-musl',
  stvoidg='strat -r void-musl',
  stvoid='strat -r void',
  starch='strat -r arch',
  stalp='strat -r alpine',
  stubu='strat -r ubuntu',
  stdeb='strat -r debian',
  brw='brl which',
}
-- }}}

doPrompt(-1)
-- vim:foldmethod=marker
