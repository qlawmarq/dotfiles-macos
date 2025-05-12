#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# .gitconfig
if [ -f ~/.gitconfig ]; then
    cp ~/.gitconfig "${SCRIPT_DIR}/.gitconfig"
    echo "✓ .gitconfig synced"
fi

# Global gitignore
if [ -f ~/.config/git/ignore ]; then
    mkdir -p "${SCRIPT_DIR}/.config/git"
    cp ~/.config/git/ignore "${SCRIPT_DIR}/.config/git/ignore"
    echo "✓ git ignore synced"
fi