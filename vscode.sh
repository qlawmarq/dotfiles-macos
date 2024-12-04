#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Setup VSCode settings
echo "Setting up VSCode settings..."
if [ -d "/Applications/Visual Studio Code.app" ]; then
    mkdir -p ~/Library/Application\ Support/Code/User
    cp "${SCRIPT_DIR}/vscode/settings.json" ~/Library/Application\ Support/Code/User/settings.json
    
    # Install VSCode extensions
    if [ -f "${SCRIPT_DIR}/vscode-extensions.txt" ]; then
        echo "Installing VSCode extensions..."
        while IFS= read -r extension; do
            code --install-extension "$extension"
        done < "${SCRIPT_DIR}/vscode-extensions.txt"
    fi
else
    echo "VSCode is not installed yet. Skipping VSCode settings..."
fi