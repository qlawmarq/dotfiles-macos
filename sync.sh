#!/bin/bash

# Check if running on macOS
if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Function to ask for confirmation
confirm() {
    read -p "$1 (y/N): " yn
    case $yn in
        [Yy]* ) return 0;;
        * ) return 1;;
    esac
}

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Sync brew
if confirm "Would you like to sync brew?"; then
    echo "Syncing brew..."
    bash "${SCRIPT_DIR}/brew/sync.sh"
fi

# Sync dotfiles
if confirm "Would you like to sync dotfiles?"; then
    echo "Syncing dotfiles..."
    bash "${SCRIPT_DIR}/dotfiles/sync.sh"
fi

# Sync git
if confirm "Would you like to sync git?"; then
    echo "Syncing git..."
    bash "${SCRIPT_DIR}/git/sync.sh"
fi

# Sync vscode
if confirm "Would you like to sync vscode?"; then
    echo "Syncing vscode..."
    bash "${SCRIPT_DIR}/vscode/sync.sh"
fi

# Sync cursor
if confirm "Would you like to sync cursor?"; then
    echo "Syncing cursor..."
    bash "${SCRIPT_DIR}/cursor/sync.sh"
fi

# Sync claude
if confirm "Would you like to sync claude?"; then
    echo "Syncing claude..."
    bash "${SCRIPT_DIR}/claude/sync.sh"
fi

echo "All configurations have been synced!"