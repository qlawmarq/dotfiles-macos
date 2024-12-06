#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Sync dotfiles
echo "Syncing dotfiles..."
# .zprofile
if [ -f ~/.zprofile ]; then
    cp ~/.zprofile "${SCRIPT_DIR}/.zprofile"
    echo "✓ .zprofile synced"
fi

# .zshrc
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc "${SCRIPT_DIR}/.zshrc"
    echo "✓ .zshrc synced"
fi
