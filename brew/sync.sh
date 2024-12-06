#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Sync Brewfile
echo "Syncing Brewfile..."
brew bundle dump --force --file="${SCRIPT_DIR}/.Brewfile"
echo "✓ Brewfile updated"