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

# .tmux.conf
if [ -f ~/.tmux.conf ]; then
    cp ~/.tmux.conf "${SCRIPT_DIR}/.tmux.conf"
    echo "✓ .tmux.conf synced"
fi
