#!/bin/bash

DIR="~/wallpapers"
MORNING="$DIR/tropic_island_morning.jpg"
DAY="$DIR/tropic_island_day.jpg"
EVENING="$DIR/tropic_island_evening.jpg"
NIGHT="$DIR/tropic_island_night.jpg"
HOUR=$(date +"%H")

if [ "$HOUR" -ge 6 ] && [ "$HOUR" -lt 12 ]; then
    WALLPAPER=$MORNING
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
    WALLPAPER=$DAY
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 22 ]; then
    WALLPAPER=$EVENING
else
    WALLPAPER=$NIGHT
fi

echo "Setting wallpaper: $WALLPAPER"
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper "DP-1,$WALLPAPER"
hyprctl hyprpaper wallpaper "DP-2,$WALLPAPER"

