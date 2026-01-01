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

# Sync VSCode extensions
echo "Syncing VSCode extensions..."
code --list-extensions | sort > "${SCRIPT_DIR}/vscode-extensions.txt"
echo "✓ VSCode extensions list updated"
