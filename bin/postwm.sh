#!/bin/bash

# spider's graphical init script

# # # # # # # # # # # # # # # # # #
# ALL BELOW IS FOR REFERENCE ONLY #
#       FUCK YOU NVIDIA 🖕        #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# nvidia-settings --load-config-only &
# fuckin nvidia, this fixes tearing?                                                                                                                                                                                                                                            #
# nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"                                                                                                                                                                      #
# xrandr --output DVI-D-0 --dpi 94 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-0 --dpi 94 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --off --output HDMI-1-1 --off --output DVI-D-1-1 --off --output HDMI-1-2 --off #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# you literally have to set this twice fucking hell linux desktop is not... great rn wayland when
xrandr --dpi 94
xrandr --dpi 94

xrandr --output DisplayPort-0 --primary --mode 2560x1440 --rate 144.00 --pos 0x0 --rotate normal --scale 1x1 --output DisplayPort-1 --mode 1920x1080 --pos 2560x180 --rotate normal --scale 1x1
# xrandr --output DisplayPort-0 --primary --mode 2560x1440 --rate 144.00 --pos 0x0 --rotate normal --scale 1x1 --output HDMI-A-0 --mode 1920x1080 --pos 2560x180 --rotate normal --scale 1x1
# for unicode input
ibus-daemon -drxR
# currently just for my cursor
xrdb ~/.Xresources &


# general binds
#sxhkd &
# wallpaper :)
# feh --bg-fill Downloads/Broken_Landscape_V.jpg
# feh --bg-fill "$HOME/.config/i3/$(find ~/.config/i3/ -name './*png' | shuf -n 1)"
# feh --bg-tile ~/Pictures/Wallpapers/Ø!.png --class "feh-background"
# feh --bg-tile ~/Pictures/Wallpapers/river_paintpractice.png
# feh --bg-tile ~/Pictures/eat a pic/void-linux-2001.png


# this is the one time where i'm doing the wrong thing but not just using 'sleep'
ensureOn(){
    if pgrep -x "$1" > /dev/null; then return; fi
    $* & # no, shellcheck, i don't think i will
}

# we're gonna do audio here y not
pipewire &

# we real fancy now
ensureOn walp.bin

# background shit
ensureOn picom
ensureOn redshift
ensureOn syncthing --no-browser

# i do not commit crimes but if i did i would be a good girl and seed my torrents
# ensureOn qbittorrent
# forground shit
# alacritty --title="todo" --class=serv,serv -e bash -c "$HOME/.cargo/bin/chore ; ssh -p 773 spider@192.168.0.61" &
# alacritty --hold --title="$(tac /var/log/pacman.log | grep -m1 '\-S \-y \-u')" --class=local,local -e bash -i -c "neofetch && python bin/archnews.py | sed -n '1,18 p' && $HOME/bin/p u; bash" &
wezterm start --class=serv bash -c "cd ~/project/git/dote && ./dote.lua ; ssh -p 773 spider@192.168.0.61" &
wezterm start --class=local bash -i -c "neofetch && python bin/archnews.py | sed -n '1,14 p' && $HOME/bin/p u; bash" &
# bin/archnews.py | sed -n '1,18 p' && $HOME/bin/p u; bash" &
# ensureOn keepassxc
# ensureOn pavucontrol-qt

# this one is batshit
export NUMEN_DMENU=j4-desktop-dmenu
#ensureOn numen "$HOME/.config/numen/off.phrases"
