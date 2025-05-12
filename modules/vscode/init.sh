#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Function to ask for confirmation
confirm() {
    read -p "$1 (y/N): " yn
    case $yn in
        [Yy]* ) return 0;;
        * ) return 1;;
    esac
}

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

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

# Setup VSCode settings
echo "Setting up VSCode settings..."
if [ -d "/Applications/Visual Studio Code.app" ]; then
    mkdir -p ~/Library/Application\ Support/Code/User
    
    # Get current versions from mise
    NODE_VERSION=$(mise current node | awk '{print $1}')
    
    # Check if Node.js is installed
    if [ -z "$NODE_VERSION" ]; then
        echo "Node.js is not installed."
        exit 1
    fi
    
    # Try to get tokens from existing config file
    CONFIG_FILE=~/Library/Application\ Support/Code/User/settings.json
    if [ -f "$CONFIG_FILE" ]; then
        # Extract GitHub token if present
        EXTRACTED_GITHUB_TOKEN=$(grep -o '"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
        if [ -n "$EXTRACTED_GITHUB_TOKEN" ]; then
            GITHUB_TOKEN="$EXTRACTED_GITHUB_TOKEN"
        fi
    fi

    # Ask for GitHub token if not already set in environment or config
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "Please enter your GitHub Personal Access Token: (https://github.com/settings/personal-access-tokens)"
        read -r GITHUB_TOKEN
    fi
    
    # Create temporary config with current versions
    echo "Updating configuration with Node.js $NODE_VERSION..."
    
    # First replace versions in a temporary file
    TMP_CONFIG=$(mktemp)
    cat "${SCRIPT_DIR}/settings.json" | \
        sed -e "s|\$NODE_VERSION|$NODE_VERSION|g" > "$TMP_CONFIG"
    
    # Then replace environment variables
    sed -e "s|\$HOME|$HOME|g" \
        -e "s|\$GITHUB_TOKEN|$GITHUB_TOKEN|g" \
        "$TMP_CONFIG" > "$CONFIG_FILE"
    
    # Clean up
    rm "$TMP_CONFIG"
    
    # Install VSCode extensions
    if [ -f "${SCRIPT_DIR}/vscode-extensions.txt" ]; then
        echo "Installing VSCode extensions..."
        if ! command -v code &> /dev/null; then
            echo "VSCode CLI command not found. Please restart your terminal and run this script again."
            exit 1
        fi
        while IFS= read -r extension; do
            code --install-extension "$extension"
        done < "${SCRIPT_DIR}/vscode-extensions.txt"
    fi
else
    echo "VSCode is not installed yet. Skipping VSCode settings..."
fi