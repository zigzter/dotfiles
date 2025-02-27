#!/usr/bin/env bash
set -e

# Wrapper script for tmux sessions and worktrees
# Usage: ./tmux-new.sh <ticket-name> <repo-group>

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <ticket-name> <repo-group: pallet|tariff>"
  exit 1
fi

ticket_name=$1
repo_group=$2

# Define repo paths
if [ "$repo_group" == "pallet" ]; then
  repos=("pallet-ui" "pallet-api")
elif [ "$repo_group" == "tariff" ]; then
  repos=("tariff-ui" "tariff-api")
else
  echo "Invalid repo group. Use 'pallet' or 'tariff'."
  exit 1
fi

# Create a tmux session with the ticket name
tmux new-session -d -s "$ticket_name" -n "${repos[0]}" "cd ${repos[0]}/$ticket_name && bash"

# Add the API repo as window 2
tmux new-window -t "$ticket_name:2" -n "${repos[1]}" "cd ${repos[1]}/$ticket_name && bash"

# Add a vertically split window for git commands
tmux new-window -t "$ticket_name:3" -n "git-commands"
tmux split-window -h -t "$ticket_name:3"
tmux send-keys -t "$ticket_name:3.0" "cd ${repos[0]}/$ticket_name && bash" C-m
tmux send-keys -t "$ticket_name:3.1" "cd ${repos[1]}/$ticket_name && bash" C-m

echo "Tmux session '$ticket_name' created with worktrees for $repo_group repos."

# Attach to the tmux session
tmux attach-session -t "$ticket_name"

