#!/bin/bash

# Check if running on macOS
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

# Sync VSCode extensions
echo "Syncing VSCode extensions..."
code --list-extensions | sort > "${SCRIPT_DIR}/vscode-extensions.txt"
echo "✓ VSCode extensions list updated"

# Sync dotfiles
echo "Syncing dotfiles..."
# .zprofile
if [ -f ~/.zprofile ]; then
    cp ~/.zprofile "${SCRIPT_DIR}/.zprofile"
    echo "✓ .zprofile synced"
fi

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

# VSCode settings
if [ -f ~/Library/Application\ Support/Code/User/settings.json ]; then
    mkdir -p "${SCRIPT_DIR}/vscode"
    cp ~/Library/Application\ Support/Code/User/settings.json "${SCRIPT_DIR}/vscode/settings.json"
    echo "✓ VSCode settings synced"
fi

echo "All configurations have been synced!" 