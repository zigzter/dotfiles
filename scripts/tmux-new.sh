#!/usr/bin/env bash
set -e

# Wrapper script for tmux sessions and worktrees
# Usage: ./tmux-new.sh <ticket-name> <repo-group> [type]

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <ticket-name> <repo-group: pallet|tariff> [type: ui|api]"
  exit 1
fi

ticket_name=$1
repo_group=$2
type=$3  # Optional: ui, api, or empty for both

# Define repo paths
if [ "$repo_group" == "pallet" ]; then
  ui_repo="pallet-ui"
  api_repo="pallet-api"
elif [ "$repo_group" == "tariff" ]; then
  ui_repo="tariff-ui"
  api_repo="tariff-api"
else
  echo "Invalid repo group. Use 'pallet' or 'tariff'."
  exit 1
fi

# Filter repos based on type
if [ "$type" == "ui" ]; then
  repos=("$ui_repo")
elif [ "$type" == "api" ]; then
  repos=("$api_repo")
else
  repos=("$ui_repo" "$api_repo")
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

# Set up remaining windows based on type
if [ "$type" != "ui" ] && [ "$type" != "api" ]; then
  # Add the API repo as window 2 (only if both types are being used)
  tmux new-window -t "$ticket_name:2" -n "${repos[1]}" "cd ${repos[1]}/$ticket_name && $SHELL"
  
  # Add a vertically split window for git commands for both repos
  tmux new-window -t "$ticket_name:3" -n "git-commands"
  tmux split-window -h -t "$ticket_name:3"
  tmux send-keys -t "$ticket_name:3.1" "cd ${repos[0]}/$ticket_name && $SHELL" C-m
  tmux send-keys -t "$ticket_name:3.2" "cd ${repos[1]}/$ticket_name && $SHELL" C-m
else
  # Create a single git window for the selected repo type
  tmux new-window -t "$ticket_name:2" -n "git-commands" "cd ${repos[0]}/$ticket_name && $SHELL"
fi

if [ "$type" == "ui" ] || [ "$type" == "api" ]; then
  echo "Tmux session '$ticket_name' created with worktree for $repo_group $type."
else
  echo "Tmux session '$ticket_name' created with worktrees for $repo_group repos."
fi

# Attach to the tmux session
tmux attach-session -t "$ticket_name:1"

