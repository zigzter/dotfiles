#!/bin/bash

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
mode=$(echo "$input" | jq -r '.output_style.name // "default"')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

RESET='\033[0m'
DIM='\033[2m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
GRAY='\033[90m'

bar() {
  local pct_raw="$1"
  local color="$2"
  local width=10
  local pct
  pct=$(printf '%.0f' "$pct_raw")
  (( pct < 0 )) && pct=0
  (( pct > 100 )) && pct=100
  local filled=$(( (pct * width + 50) / 100 ))
  local empty=$(( width - filled ))
  local filled_str='' empty_str=''
  for ((i = 0; i < filled; i++)); do filled_str+='-'; done
  for ((i = 0; i < empty; i++)); do empty_str+='-'; done
  printf '%b%s%b%b%s%b' "$color" "$filled_str" "$RESET" "$GRAY" "$empty_str" "$RESET"
}

color_for_pct() {
  local pct
  pct=$(printf '%.0f' "$1")
  if (( pct >= 80 )); then
    echo "$RED"
  elif (( pct >= 50 )); then
    echo "$YELLOW"
  else
    echo "$GREEN"
  fi
}

out="${DIM}[${mode}]${RESET} ${model}"

if [ -n "$used_pct" ]; then
  color=$(color_for_pct "$used_pct")
  out="${out} ${DIM}|${RESET} Ctx $(bar "$used_pct" "$color") $(printf '%.0f' "$used_pct")%"
fi

if [ -n "$five_hour" ]; then
  color=$(color_for_pct "$five_hour")
  reset_label="5h"
  [ -n "$five_hour_resets_at" ] && reset_label=$(date -d "@${five_hour_resets_at}" '+%-I:%M%p' | tr '[:upper:]' '[:lower:]')
  out="${out} ${DIM}|${RESET} ${reset_label} $(bar "$five_hour" "$color") $(printf '%.0f' "$five_hour")%"
fi

printf "%b\n" "$out"
