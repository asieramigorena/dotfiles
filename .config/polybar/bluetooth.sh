#!/bin/bash
if bluetoothctl show | grep -q "Powered: yes"; then
    connected=$(bluetoothctl devices Connected 2>/dev/null | wc -l)
    if [ "$connected" -gt 0 ]; then
        echo "BT:$connected"
    else
        echo "BT"
    fi
else
    echo "BT off"
fi
