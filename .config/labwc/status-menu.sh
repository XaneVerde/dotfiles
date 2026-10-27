#!/bin/sh

# 1. Fetch raw metrics directly from sysfs (lightning fast, zero overhead)
BAT_CAP=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
BAT_STAT=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
TIME_NOW=$(date +"%H:%M")

# 2. Translate battery state text into clean indicators
case "$BAT_STAT" in
    "Charging")    STAT_STR="Charging" ;;
    "Full")        STAT_STR="Full" ;;
    "Discharging") STAT_STR="On Battery" ;;
    *)             STAT_STR="Unknown" ;;
esac

# 3. Output standard Openbox/Labwc XML menu structure
echo "<openbox_menu>"
if [ -n "$BAT_CAP" ]; then
    echo "  <item label=\"🔋 Battery: ${BAT_CAP}% (${STAT_STR})\"></item>"
else
    echo "  <item label=\"🔋 Battery: Not Found\"></item>"
fi
echo "  <item label=\"🕒 Time: ${TIME_NOW}\"></item>"
echo "</openbox_menu>"

