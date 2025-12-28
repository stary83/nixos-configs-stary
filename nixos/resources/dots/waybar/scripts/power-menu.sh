#!/bin/bash
SCREEN_WIDTH=$(hyprctl monitors -j | jq '.[0].width')

options="Shutdown\nReboot\nSleep"
chosen=$(echo -e "$options" | wofi \
	-dmenu \
	-location 3 \
	-anchor 3 \
	-lines 3)

case $chosen in
"Shutdown")
	poweroff
	;;
"Reboot")
	reboot
	;;
"Sleep")
	suspend
	;;
esac
