#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
        mv "$TMP_CONFIG" "${SCRIPT_DIR}/claude_desktop_config.json"
        echo "✓ Claude Desktop configuration synced with version placeholders"
    else
        rm "$TMP_CONFIG"
        echo "Error: Failed to process Claude Desktop configuration"
        exit 1
    fi
else
    echo "Claude Desktop configuration file not found"
fi