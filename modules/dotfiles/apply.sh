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

# Setup dotfiles
echo "Setting up dotfiles..."

# Setup .zshenv (loaded for all zsh sessions including SSH)
cp "${SCRIPT_DIR}/.zshenv" ~/.zshenv

# Setup .zprofile
cp "${SCRIPT_DIR}/.zprofile" ~/.zprofile

# Setup .zshrc
cp "${SCRIPT_DIR}/.zshrc" ~/.zshrc

echo "✓ Shell configuration applied"
echo ""
echo "Note: tmux configuration is now managed by the 'tmux' module"
