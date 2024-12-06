#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Sync VSCode extensions
echo "Syncing VSCode extensions..."
code --list-extensions | sort > "${SCRIPT_DIR}/vscode-extensions.txt"
echo "✓ VSCode extensions list updated"

# VSCode settings
if [ -f ~/Library/Application\ Support/Code/User/settings.json ]; then
    cp ~/Library/Application\ Support/Code/User/settings.json "${SCRIPT_DIR}/vscode/settings.json"
    echo "✓ VSCode settings synced"
fi