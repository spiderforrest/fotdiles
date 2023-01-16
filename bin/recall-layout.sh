#!/usr/bin/bash

SEL=`ls ~/.config/herbstluftwm/layouts/ | rofi -dmenu -p "Choose a layout:" -i -l 11`
herbstclient load "$(cat ~/.config/herbstluftwm/layouts/$SEL)"
