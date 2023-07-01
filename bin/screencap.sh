#!/usr/bin/env bash

sudo modprobe -r v4l2loopback
sudo modprobe v4l2loopback video_nr=12 card_label="primary screen cap" exclusive_caps=1
sudo ffmpeg -probesize 100M -framerate "$1" -f x11grab -video_size 1280x720 -i :0.0+0,0 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video12
