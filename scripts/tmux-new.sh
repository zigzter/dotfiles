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

# Create git worktrees for each repo
for repo in "${repos[@]}"; do
  echo "Setting up worktree for $repo..."
  
  # Check if repo directory exists
  if [ ! -d "$repo" ]; then
    echo "Error: Repository directory '$repo' not found"
    exit 1
  fi
  
  # Navigate to repo
  cd "$repo"
  
  # Ensure we have the latest from remote
  git fetch origin
  
  # Check if worktree already exists
  if [ -d "$ticket_name" ]; then
    echo "Worktree for $repo/$ticket_name already exists."
  else
    # Create new branch based on main/master for the ticket
    branch_name="$ticket_name"
    main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    git worktree add "$ticket_name" -b "$branch_name" "origin/$main_branch"
    echo "Created worktree at $repo/$ticket_name"
  fi
  
  # Return to original directory
  cd - > /dev/null
done

# Create a tmux session with the ticket name
tmux new-session -d -s "$ticket_name" -n "${repos[0]}" "cd ${repos[0]}/$ticket_name && $SHELL"

# Add the API repo as window 2
tmux new-window -t "$ticket_name:2" -n "${repos[1]}" "cd ${repos[1]}/$ticket_name && $SHELL"

# Add a vertically split window for git commands
tmux new-window -t "$ticket_name:3" -n "git-commands"
tmux split-window -h -t "$ticket_name:3"
tmux send-keys -t "$ticket_name:3.1" "cd ${repos[0]}/$ticket_name && $SHELL" C-m
tmux send-keys -t "$ticket_name:3.2" "cd ${repos[1]}/$ticket_name && $SHELL" C-m

echo "Tmux session '$ticket_name' created with worktrees for $repo_group repos."

# Attach to the tmux session
tmux attach-session -t "$ticket_name:1"

