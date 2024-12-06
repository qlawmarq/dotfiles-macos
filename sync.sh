#!/bin/bash

# Check if running on macOS
if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Sync brew
echo "Syncing brew..."
bash "${SCRIPT_DIR}/brew/sync.sh"

# Sync dotfiles
echo "Syncing dotfiles..."
bash "${SCRIPT_DIR}/dotfiles/sync.sh"

# Sync editor
echo "Syncing editor..."
bash "${SCRIPT_DIR}/editor/sync.sh"

# Sync git
echo "Syncing git..."
bash "${SCRIPT_DIR}/git/sync.sh"

# Sync claude
echo "Syncing claude..."
bash "${SCRIPT_DIR}/claude/sync.sh"

echo "All configurations have been synced!"