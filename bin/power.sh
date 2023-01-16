#!/bin/bash

# holy shit this is tacky
# fonts get fucked if it runs as root
#su spider -c "/home/spider/.config/rofi/applets/applets/powermenu.sh"
runuser -u spider "/home/spider/.config/rofi/applets/applets/powermenu.sh"

case $? in
	
	0)
		exit 0
	;;

	4)
		zzz -S
	;;

	5)
		runit-init 0
	;;

	6)
		runit-init 6
esac
