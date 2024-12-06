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
    # Get GitHub token from existing config file
    GITHUB_TOKEN=$(grep -o '"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"' "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" | cut -d'"' -f4)
    
    # Get current runtime versions from mise
    NODE_VERSION=$(mise current node | awk '{print $1}')
    PYTHON_VERSION=$(mise current python | awk '{print $1}')
    
    # Create temporary file for processing
    TMP_CONFIG=$(mktemp)
    
    # Process the configuration file in steps
    cat "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" | \
    # First, replace the actual versions with VERSION placeholders
    sed -E "s|node/${NODE_VERSION}|node/VERSION_NODE|g; \
            s|python/${PYTHON_VERSION}|python/VERSION_PYTHON|g" | \
    # Then, replace the home directory with $HOME
    sed "s|${HOME}|\$HOME|g" | \
    # Finally, replace the GitHub token with $GITHUB_TOKEN
    sed "s|${GITHUB_TOKEN}|\$GITHUB_TOKEN|g" \
    > "$TMP_CONFIG"
    
    # Check if the file was processed correctly
    if [ -s "$TMP_CONFIG" ]; then
        mv "$TMP_CONFIG" "${SCRIPT_DIR}/claude/claude_desktop_config.json"
        echo "✓ Claude Desktop configuration synced with version placeholders"
    else
        rm "$TMP_CONFIG"
        echo "Error: Failed to process Claude Desktop configuration"
        exit 1
    fi
else
    echo "Claude Desktop configuration file not found"
fi

echo "All configurations have been synced!"