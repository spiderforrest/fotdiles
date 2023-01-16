#!/usr/bin/bash

FI=`rofi -dmenu -p "Enter layout name:" `
herbstclient dump > ~/.config/herbstluftwm/layouts/$FI
