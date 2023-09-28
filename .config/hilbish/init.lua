-- Default Hilbish config
local lunacolors = require 'lunacolors'
local bait = require 'bait'
local ansikit = require 'ansikit'

local function alias(tbl)
	for name, command in pairs(tbl) do
		hilbish.alias(name, command)
	end
end

local function doPrompt(exit_status)
  local color_fmt
  if exit_status == 0 then
    color_fmt = '{green}'
  elseif exit_status == 1 then
    color_fmt = '{red}'
  else
    color_fmt = '{yellow}'
  end
	hilbish.prompt(lunacolors.format(
		'{blue}%h {bold}{blue}@ {reset}{cyan}%d ' .. color_fmt .. '∆ '
	))
end

bait.catch('command.exit', function(code)
	doPrompt(code)
end)

bait.catch('hilbish.vimMode', function(mode)
	if mode ~= 'insert' then
		ansikit.cursorStyle(ansikit.blockCursor)
	else
		ansikit.cursorStyle(ansikit.lineCursor)
	end
end)

-- aliases
-- shorthands
alias{
v='nvim',
vw='nvim "+lua writing()"', -- it feels real good changing that to a lua funtion call oooooooo
ni='neovide --multigrid',
suv='sudoedit',
chkdns='ping 8.8.8.8',
la=[[ls -Bbp1 -gah --group-directories-first --time-style=+%b\ %d --color=auto --hyperlink=auto]],
ls='ls -BNp1 --group-directories-first --color=auto --hyperlink=auto',
ch='chore',
godo='chore',
gitfix='sed -i s/mindforrest/spiderforrest/ */.git/config',
binfix='chmod +x ~/bin/*',
fastread='fsrx',
serv='ssh spider@spood.org -p 773',
fserv='sftp -P 773 spider@spood.org',
why_would_you_do_this_dude_why='xclip -o | shuf',
[':q']="exit", -- ...
xmpp="profanity -a spider@spood.org -t boothj5_slack",
cold="notify-send 'Numen dormant' && numen $HOME/.config/numen/off.phrases",
nile="$HOME/project/git/nile/bin/nile",
-- nuke() { rm -r "$1" && echo "rm -r\"\$*\" \"./$1\"" >> "$HOME/bin/clean_junk"; }
prosody="TERM=xterm ssh -J spood.org:773 admin@xmpp.spood.org -i .aws/spider.pem",
mine="__GL_THREADED_OPTIMIZATIONS=0 multimc -l 'the final gay'",

-- fixes/improvements
sl='sl -la',
rm='rm -rI',
btop='btop --utf-force',
-- allow aliasi to apply after sudo
sudo="/bin/sudo ",
-- some files start with a bit of garbo bytes, grep misbehaves to protect output but i ain't a pussy
grep='grep --color=auto -a',

-- bedrock
stvoidm='strat -r void-musl',
stvoid='strat -r void',
starch='strat -r arch',
stalp='strat -r alpine',
stubu='strat -r ubuntu',
stdeb='strat -r debian',
brw='brl which',
}


doPrompt(0)
