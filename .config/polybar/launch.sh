#!/bin/bash

killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# Detect active monitors (those with a resolution assigned by xrandr)
ACTIVE=$(xrandr | awk '/ connected / && /[0-9]+x[0-9]+\+/ {print $1}')
LAPTOP="eDP-1"
EXTERNAL="DP-1"

LAPTOP_ON=false
EXTERNAL_ON=false
[[ "$ACTIVE" == *"$LAPTOP"* ]]   && LAPTOP_ON=true
[[ "$ACTIVE" == *"$EXTERNAL"* ]] && EXTERNAL_ON=true

if $LAPTOP_ON && $EXTERNAL_ON; then
    # Dual monitor (extended): one bar per screen
    MONITOR=$LAPTOP   polybar main     &
    MONITOR=$EXTERNAL polybar external &
elif $EXTERNAL_ON; then
    # External monitor only
    MONITOR=$EXTERNAL polybar main &
elif $LAPTOP_ON; then
    # Laptop only
    MONITOR=$LAPTOP polybar main &
else
    # Fallback
    polybar main &
fi
