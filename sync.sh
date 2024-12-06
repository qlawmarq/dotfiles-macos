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
brew bundle dump --force --file="${SCRIPT_DIR}/brew/.Brewfile"
echo "✓ Brewfile updated"

# Sync VSCode extensions
echo "Syncing VSCode extensions..."
code --list-extensions | sort > "${SCRIPT_DIR}/editor/vscode-extensions.txt"
echo "✓ VSCode extensions list updated"

# Sync dotfiles
echo "Syncing dotfiles..."
# .zprofile
if [ -f ~/.zprofile ]; then
    cp ~/.zprofile "${SCRIPT_DIR}/dotfiles/.zprofile"
    echo "✓ .zprofile synced"
fi

# .gitconfig
if [ -f ~/.gitconfig ]; then
    cp ~/.gitconfig "${SCRIPT_DIR}/git/.gitconfig"
    echo "✓ .gitconfig synced"
fi

# Global gitignore
if [ -f ~/.config/git/ignore ]; then
    mkdir -p "${SCRIPT_DIR}/git/.config/git"
    cp ~/.config/git/ignore "${SCRIPT_DIR}/git/.config/git/ignore"
    echo "✓ git ignore synced"
fi

# VSCode settings
if [ -f ~/Library/Application\ Support/Code/User/settings.json ]; then
    mkdir -p "${SCRIPT_DIR}/editor"
    cp ~/Library/Application\ Support/Code/User/settings.json "${SCRIPT_DIR}/editor/vscode/settings.json"
    echo "✓ VSCode settings synced"
fi

# Sync Claude Desktop configuration
echo "Syncing Claude Desktop configuration..."
CLAUDE_CONFIG_DIR=~/Library/Application\ Support/Claude
if [ -f "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" ]; then
    HOME_ESCAPED=$(echo "$HOME" | sed 's/\//\\\//g')
    
    # Get GitHub token from existing config file
    GITHUB_TOKEN=$(grep -o '"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"' "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" | cut -d'"' -f4)
    GITHUB_TOKEN_ESCAPED=$(echo "$GITHUB_TOKEN" | sed 's/\//\\\//g')
    
    # Replace actual values with variables and copy
    cat "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" | \
    sed "s|$HOME_ESCAPED|\$HOME|g; s|$GITHUB_TOKEN_ESCAPED|\$GITHUB_TOKEN|g" \
    > "${SCRIPT_DIR}/claude/claude_desktop_config.json"
    echo "✓ Claude Desktop configuration synced (variables templated)"
fi

echo "All configurations have been synced!"