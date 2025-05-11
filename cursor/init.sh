#!/bin/bash

echo "Starting Cursor editor installation..."

# Function to ask for confirmation
confirm() {
    read -p "$1 (y/N): " yn
    case $yn in
        [Yy]* ) return 0;;
        * ) return 1;;
    esac
}

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if mise is installed
if ! command -v mise &> /dev/null; then
    echo "mise is not installed. Please install mise first."
    exit 1
else
    echo "mise is already installed"
fi

# Check if node is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js first."
    exit 1
else
    echo "Node.js is already installed"
fi

# Cursor configuration
if [ -d "/Applications/Cursor.app" ]; then
    # Create MCP directory if not exists
    echo "Setting up MCP directory..."
    mkdir -p "$HOME/Codes"

    echo "Setting up Cursor configuration..."
    CURSOR_CONFIG_DIR=~/.cursor
    mkdir -p "$CURSOR_CONFIG_DIR"
    
    # Get current versions from mise
    NODE_VERSION=$(mise current node | awk '{print $1}')
    
    # Check if runtimes are installed
    if [ -z "$NODE_VERSION" ]; then
        echo "Node.js is not installed."
        exit 1
    fi
    
    # Try to get tokens from existing config file
    CONFIG_FILE="$CURSOR_CONFIG_DIR/mcp.json"
    if [ -f "$CONFIG_FILE" ]; then
        # Extract GitHub token if present
        EXTRACTED_GITHUB_TOKEN=$(grep -o '"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
        if [ -n "$EXTRACTED_GITHUB_TOKEN" ]; then
            GITHUB_TOKEN="$EXTRACTED_GITHUB_TOKEN"
        fi
        # Extract Brave API key if present
        EXTRACTED_BRAVE_API_KEY=$(grep -o '"BRAVE_API_KEY": "[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
        if [ -n "$EXTRACTED_BRAVE_API_KEY" ]; then
            BRAVE_API_KEY="$EXTRACTED_BRAVE_API_KEY"
        fi
    fi

    # Ask for GitHub token if not already set in environment or config
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "Please enter your GitHub Personal Access Token: (https://github.com/settings/personal-access-tokens)"
        read -r GITHUB_TOKEN
    fi

    # Ask for Brave API key if not already set in environment or config
    if [ -z "$BRAVE_API_KEY" ]; then
        echo "Please enter your Brave API Key: (https://api-dashboard.search.brave.com/app/keys)"
        read -r BRAVE_API_KEY
    fi
    
    # Create temporary config with current versions
    echo "Updating configuration with Node.js $NODE_VERSION..."
    
    # First replace versions in a temporary file
    TMP_CONFIG=$(mktemp)
    cat "${SCRIPT_DIR}/mcp.json" | \
        sed -e "s|\$NODE_VERSION|$NODE_VERSION|g" > "$TMP_CONFIG"
    
    # Then replace environment variables
    sed -e "s|\$HOME|$HOME|g" \
        -e "s|\$GITHUB_TOKEN|$GITHUB_TOKEN|g" \
        -e "s|\$BRAVE_API_KEY|$BRAVE_API_KEY|g" \
        "$TMP_CONFIG" > "$CURSOR_CONFIG_DIR/mcp.json"
    
    # Clean up
    rm "$TMP_CONFIG"
    
    echo "✓ Cursor configuration updated successfully"
else
    echo "Cursor is not installed..."
fi 