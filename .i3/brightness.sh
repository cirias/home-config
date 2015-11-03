#!/bin/bash

BRIGHTNESS=/sys/class/backlight/intel_backlight/brightness
var1=-10
if [ $1 -eq 1 ]; then
var1=10
fi
var1=$(($var1 + $(cat $BRIGHTNESS)))
echo $var1 > $BRIGHTNESS
