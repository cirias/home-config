#!/bin/bash

xrandr --output HDMI1 --left-of eDP1 --auto --output DP2 --left-of HDMI1 --auto
#xrandr --output DP2 --left-of HDMI1 --auto

i3-msg workspace 1 && i3-msg move workspace to output DP2
i3-msg workspace 2 && i3-msg move workspace to output HDMI1
i3-msg workspace 3 && i3-msg move workspace to output eDP1
