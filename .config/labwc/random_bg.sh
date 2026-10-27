#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpaper"
INTERVAL=60 # Time in seconds (10 minutes)

while true; do
  CMD="swaybg"
  while read -r output; do
    RANDOM_PIC=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)
    CMD="$CMD -o '$output' -i '$RANDOM_PIC' -m fill"
  done < <(wlr-randr | grep -E '^[A-Za-z0-9_-]+' | awk '{print $1}')

  # Run the new instance
  eval "$CMD &"
  NEW_PID=$!

  # Wait briefly and kill old swaybg instances to avoid screen flickering
  sleep 2
  kill $(pgrep swaybg | grep -v $NEW_PID) 2>/dev/null

  sleep $INTERVAL
done
