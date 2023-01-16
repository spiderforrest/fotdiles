#!/usr/bin/bash

MODULE=$1


case "$MODULE" in
    nvidia)
        nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,utilization.memory,power.draw --format=csv,noheader
    ;;
    network)
        CON=$(nmcli -c no networking connectivity)
        if [[ $CON = "full" ]] ; then
            nmcli -g ip4.address connection show eth0 | head -c -4
        else
            echo "$CON"
        fi
    ;;
    sink)
        pactl get-sink-volume @DEFAULT_SINK@ | grep -E -o '[0-9]+%' | tail -n 1
        ;;
    source)
        pactl get-source-volume @DEFAULT_SOURCE@ | grep -E -o '[0-9]+%' | tail -n 1
        ;;
esac

