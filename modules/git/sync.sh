#!/bin/bash

# 共通ユーティリティを読み込む
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ -f "$DOTFILES_DIR/lib/utils.sh" ]; then
    source "$DOTFILES_DIR/lib/utils.sh"
else
    echo "Error: utils.sh not found at $DOTFILES_DIR/lib/utils.sh"
    exit 1
fi

check_macos

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