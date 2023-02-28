#!/bin/bash

# spider's graphical init script

# # # # # # # # # # # # # # # # # #
# ALL BELOW IS FOR REFERENCE ONLY #
#       FUCK YOU NVIDIA 🖕        #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#nvidia-settings --load-config-only &
# fuckin nvidia, this fixes tearing?                                                                                                                                                                                                                                            #
# nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"                                                                                                                                                                      #
# xrandr --output DVI-D-0 --dpi 94 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-0 --dpi 94 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --off --output HDMI-1-1 --off --output DVI-D-1-1 --off --output HDMI-1-2 --off #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# you literally have to set this twice fucking hell linux desktop is not... great rn wayland when
xrandr --dpi 94
xrandr --dpi 94
# for unicode input
ibus-daemon -drxR
# currently just for my cursor
xrdb ~/.Xresources &
# general binds
#sxhkd &
# wallpaper :)
#feh --bg-fill Downloads/Broken_Landscape_V.jpg
#feh --bg-fill "$HOME/.config/i3/$(find ~/.config/i3/ -name './*png' | shuf -n 1)"
# feh --bg-tile ~/Pictures/Wallpapers/Ø!.png --class "feh-background"
# feh --bg-tile ~/Pictures/Wallpapers/river_paintpractice.png
# this is the one time where i'm doing the wrong thing but not just using 'sleep'
ensureOn(){
    if pgrep -x "$1" > /dev/null; then return; fi
    "$*" &
}

# background shit
ensureOn picom
ensureOn redshift
ensureOn syncthing --no-browser

# forground shit
alacritty --title="todo" --class=serv,serv -e bash -c "$HOME/.cargo/bin/chore ; ssh -p 773 spider@192.168.0.61" &
alacritty --hold --title="$(tac /var/log/pacman.log | grep -m1 '\-S \-y \-u')" --class=local,local -e bash -i -c "neofetch && python bin/archnews.py | sed -n '1,18 p' && $HOME/bin/p u; bash" &
# ensureOn keepassxc
# ensureOn pavucontrol-qt
