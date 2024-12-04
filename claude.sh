#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check and setup Claude Desktop configuration
if [ -d "/Applications/Claude.app" ]; then
    echo "Setting up Claude Desktop configuration..."
    CLAUDE_CONFIG_DIR=~/Library/Application\ Support/Claude
    mkdir -p "$CLAUDE_CONFIG_DIR"
    cp "${SCRIPT_DIR}/claude_desktop_config.json" "$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
else
    echo "Claude Desktop is not installed. Please install it first using 'brew install --cask claude'"
    echo "Skipping Claude Desktop configuration..."
fi