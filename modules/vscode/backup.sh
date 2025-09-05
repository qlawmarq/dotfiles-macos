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

# VSCode settings
if [ -f ~/Library/Application\ Support/Code/User/settings.json ]; then
    echo "Found existing configuration file"
    
    # Get GitHub token from existing config file
    GITHUB_TOKEN=$(grep -o '"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"' ~/Library/Application\ Support/Code/User/settings.json | cut -d'"' -f4)
    echo "Extracted GitHub token: ${GITHUB_TOKEN:+[token exists]}"
    
    # Get current runtime versions from mise
    NODE_VERSION=$(mise current node | awk '{print $1}')
    echo "Current version - Node: $NODE_VERSION"
    
    # Create temporary file for processing
    TMP_CONFIG=$(mktemp)
    echo "Created temporary file: $TMP_CONFIG"
    
    # Process the configuration file in a single sed command
    cat ~/Library/Application\ Support/Code/User/settings.json | \
    sed -E "s|node/[0-9]+\.[0-9]+\.[0-9]+|node/\$NODE_VERSION|g; \
            s|${HOME}|\$HOME|g; \
            s|\"GITHUB_PERSONAL_ACCESS_TOKEN\": \"[^\"]*\"|\"GITHUB_PERSONAL_ACCESS_TOKEN\": \"\$GITHUB_TOKEN\"|g" \
    > "$TMP_CONFIG"
    
    echo "Configuration processed. Checking file size..."
    
    # Check if the file was processed correctly
    if [ -s "$TMP_CONFIG" ]; then
        echo "Moving processed configuration to template..."
        mv "$TMP_CONFIG" "${SCRIPT_DIR}/settings.json"
        echo "✓ VSCode settings synced with version placeholders"
    else
        echo "Error: Processed configuration file is empty"
        rm "$TMP_CONFIG"
        exit 1
    fi
else
    echo "VSCode settings file not found at ~/Library/Application Support/Code/User/settings.json"
fi