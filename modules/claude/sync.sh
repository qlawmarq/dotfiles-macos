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

# Sync Claude Desktop configuration
echo "Syncing Claude Desktop configuration..."
CLAUDE_CONFIG_DIR=~/Library/Application\ Support/Claude
if [ -f "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" ]; then
    echo "Found existing configuration file"
    
    # Get GitHub token from existing config file
    GITHUB_TOKEN=$(grep -o '"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"' "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" | cut -d'"' -f4)
    echo "Extracted GitHub token: ${GITHUB_TOKEN:+[token exists]}"
    
    # Get current runtime versions from mise
    NODE_VERSION=$(mise current node | awk '{print $1}')
    PYTHON_VERSION=$(mise current python | awk '{print $1}')
    echo "Current versions - Node: $NODE_VERSION, Python: $PYTHON_VERSION"
    
    # Create temporary file for processing
    TMP_CONFIG=$(mktemp)
    echo "Created temporary file: $TMP_CONFIG"
    
    # Process the configuration file in a single sed command
    cat "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" | \
    sed -E "s|node/[0-9]+\.[0-9]+\.[0-9]+|node/\$NODE_VERSION|g; \
            s|python/[0-9]+\.[0-9]+\.[0-9]+|python/\$PYTHON_VERSION|g; \
            s|${HOME}|\$HOME|g; \
            s|\"GITHUB_PERSONAL_ACCESS_TOKEN\": \"[^\"]*\"|\"GITHUB_PERSONAL_ACCESS_TOKEN\": \"\$GITHUB_TOKEN\"|g; \
    > "$TMP_CONFIG"
    
    echo "Configuration processed. Checking file size..."
    
    # Check if the file was processed correctly
    if [ -s "$TMP_CONFIG" ]; then
        echo "Moving processed configuration to template..."
        mv "$TMP_CONFIG" "${SCRIPT_DIR}/claude_desktop_config.json"
        echo "✓ Claude Desktop configuration synced with version placeholders"
    else
        echo "Error: Processed configuration file is empty"
        rm "$TMP_CONFIG"
        exit 1
    fi
else
    echo "Claude Desktop configuration file not found at $CLAUDE_CONFIG_DIR/claude_desktop_config.json"
fi