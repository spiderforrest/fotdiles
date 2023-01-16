#!/bin/bash
light -s sysfs/backlight/acpi_video0 -U 7
while true; do
	light -s sysfs/backlight/acpi_video0 -U 7
	sleep 0.005
	light -s sysfs/backlight/acpi_video0 -A 7
	sleep 0.001
done
