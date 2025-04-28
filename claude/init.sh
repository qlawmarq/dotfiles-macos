#!/bin/bash

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
fi

# Check if uv is installed
if ! command -v uvx &> /dev/null; then
    echo "uvx could not be found"
    if command -v pip &> /dev/null; then
        pip install uv
    elif command -v pip3 &> /dev/null; then
        pip3 install uv
    else
        echo "pip or pip3 is not installed. Please install pip or pip3 first."
        exit 1
    fi
fi

# Check if node is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# install mcp server-filesystem if not installed
if ! npm list -g | grep -q "@modelcontextprotocol/server-filesystem"; then
    npm install @modelcontextprotocol/server-filesystem -g
fi

# Claude Desktop configuration
if [ -d "/Applications/Claude.app" ]; then
    # Create MCP directory if not exists
    echo "Setting up MCP directory..."
    mkdir -p "$HOME/Codes"

    echo "Setting up Claude Desktop configuration..."
    CLAUDE_CONFIG_DIR=~/Library/Application\ Support/Claude
    mkdir -p "$CLAUDE_CONFIG_DIR"
    
    # Get current versions from mise
    PYTHON_VERSION=$(mise current python | awk '{print $1}')
    NODE_VERSION=$(mise current node | awk '{print $1}')
    
    # Check if runtimes are installed
    if [ -z "$PYTHON_VERSION" ]; then
        echo "Python is not installed."
        exit 1
    fi
    
    if [ -z "$NODE_VERSION" ]; then
        echo "Node.js is not installed."
        exit 1
    fi
    
    # Try to get tokens from existing config file
    CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
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
        echo "Please enter your GitHub Personal Access Token:"
        read -r GITHUB_TOKEN
    fi

    # Ask for Brave API key if not already set in environment or config
    if [ -z "$BRAVE_API_KEY" ]; then
        echo "Please enter your Brave API Key:"
        read -r BRAVE_API_KEY
    fi
    
    # Create temporary config with current versions
    echo "Updating configuration with Python $PYTHON_VERSION and Node.js $NODE_VERSION..."
    
    # First replace versions in a temporary file
    TMP_CONFIG=$(mktemp)
    cat "${SCRIPT_DIR}/claude_desktop_config.json" | \
        perl -pe "s/$PYTHON_VERSION/$PYTHON_VERSION/g" | \
        perl -pe "s/$NODE_VERSION/$NODE_VERSION/g" > "$TMP_CONFIG"
    
    # Then replace environment variables
    sed -e "s|\$HOME|$HOME|g" \
        -e "s|\$GITHUB_TOKEN|$GITHUB_TOKEN|g" \
        -e "s|\$BRAVE_API_KEY|$BRAVE_API_KEY|g" \
        "$TMP_CONFIG" > "$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
    
    # Clean up
    rm "$TMP_CONFIG"
    
    echo "✓ Claude Desktop configuration updated successfully"
else
    echo "Claude Desktop is not installed..."
fi