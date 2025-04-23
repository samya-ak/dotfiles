#!/bin/bash

# sudo visudo
# add -> <your-username> ALL=(ALL) NOPASSWD: /bin/brightnessctl
#
# Run this script every 30 minutes
# crontab -e
# add -> */30 * * * * /home/your-username/.config/i3/adjust_brightness.sh
# Get current hour
HOUR=$(date +"%H")

# Set brightness based on time
if [ "$HOUR" -ge 6 ] && [ "$HOUR" -lt 18 ]; then
    # Daytime: brighter
    sudo brightnessctl set 75%
else
    # Nighttime: dimmer
    sudo brightnessctl set 30%
fi

