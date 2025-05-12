#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Sync Cursor configuration
echo "Syncing Cursor configuration..."
CURSOR_CONFIG_DIR=~/.cursor
if [ -f "$CURSOR_CONFIG_DIR/mcp.json" ]; then
    echo "Found existing configuration file"
    
    # Get GitHub token from existing config file
    GITHUB_TOKEN=$(grep -o '"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"' "$CURSOR_CONFIG_DIR/mcp.json" | cut -d'"' -f4)
    echo "Extracted GitHub token: ${GITHUB_TOKEN:+[token exists]}"
    
    # Get Brave API key from existing config file
    BRAVE_API_KEY=$(grep -o '"BRAVE_API_KEY": "[^"]*"' "$CURSOR_CONFIG_DIR/mcp.json" | cut -d'"' -f4)
    echo "Extracted Brave API key: ${BRAVE_API_KEY:+[key exists]}"
    
    # Get current runtime versions from mise
    NODE_VERSION=$(mise current node | awk '{print $1}')
    echo "Current version - Node: $NODE_VERSION"
    
    # Create temporary file for processing
    TMP_CONFIG=$(mktemp)
    echo "Created temporary file: $TMP_CONFIG"
    
    # Process the configuration file in a single sed command
    cat "$CURSOR_CONFIG_DIR/mcp.json" | \
    sed -E "s|node/[0-9]+\.[0-9]+\.[0-9]+|node/\$NODE_VERSION|g; \
            s|${HOME}|\$HOME|g; \
            s|\"GITHUB_PERSONAL_ACCESS_TOKEN\": \"[^\"]*\"|\"GITHUB_PERSONAL_ACCESS_TOKEN\": \"\$GITHUB_TOKEN\"|g; \
            s|\"BRAVE_API_KEY\": \"[^\"]*\"|\"BRAVE_API_KEY\": \"\$BRAVE_API_KEY\"|g" \
    > "$TMP_CONFIG"
    
    echo "Configuration processed. Checking file size..."
    
    # Check if the file was processed correctly
    if [ -s "$TMP_CONFIG" ]; then
        echo "Moving processed configuration to template..."
        mv "$TMP_CONFIG" "${SCRIPT_DIR}/mcp.json"
        echo "✓ Cursor configuration synced with version placeholders"
    else
        echo "Error: Processed configuration file is empty"
        rm "$TMP_CONFIG"
        exit 1
    fi
else
    echo "Cursor configuration file not found at $CURSOR_CONFIG_DIR/mcp.json"
fi 