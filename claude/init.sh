#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create MCP directory if not exists
echo "Setting up MCP directory..."
mkdir -p "$HOME/MCP"

# Claude Desktop configuration
if [ -d "/Applications/Claude.app" ]; then
    echo "Setting up Claude Desktop configuration..."
    CLAUDE_CONFIG_DIR=~/Library/Application\ Support/Claude
    mkdir -p "$CLAUDE_CONFIG_DIR"
    
    # Ask for GitHub token
    echo "Please enter your GitHub Personal Access Token:"
    read -r GITHUB_TOKEN
    
    # Replace variables with actual values
    sed "s|\$HOME|$HOME|g; s|\$GITHUB_TOKEN|$GITHUB_TOKEN|g" "${SCRIPT_DIR}/claude_desktop_config.json" > "$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
else
    echo "Claude Desktop is not installed..."
fi