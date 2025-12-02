#!/bin/bash

# Load utils
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ -f "$DOTFILES_DIR/lib/utils.sh" ]; then
    source "$DOTFILES_DIR/lib/utils.sh"
else
    echo "Error: utils.sh not found at $DOTFILES_DIR/lib/utils.sh"
    exit 1
fi

check_macos

# Sync dotfiles
echo "Syncing dotfiles..."
# .zshenv
if [ -f ~/.zshenv ]; then
    cp ~/.zshenv "${SCRIPT_DIR}/.zshenv"
    echo "✓ .zshenv synced"
fi

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

echo ""
echo "Note: tmux configuration is now managed by the 'tmux' module"
