#!/bin/bash

# Read common utils
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ -f "$DOTFILES_DIR/lib/utils.sh" ]; then
    source "$DOTFILES_DIR/lib/utils.sh"
else
    echo "Error: utils.sh not found at $DOTFILES_DIR/lib/utils.sh"
    exit 1
fi

check_macos

# Check if mise is installed
if ! command_exists mise; then
    print_error "mise is not installed. Please install mise first."
    exit 1
else
    print_info "mise is already installed"
fi

# Check if node is installed
if ! command_exists node; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
else
    print_info "Node.js is already installed"
fi

# Setup VSCode settings
print_info "Setting up VSCode settings..."
if [ -d "/Applications/Visual Studio Code.app" ]; then
    mkdir -p ~/Library/Application\ Support/Code/User
    
    # Get current versions from mise
    NODE_VERSION=$(mise current node | awk '{print $1}')
    
    # Check if Node.js is installed
    if [ -z "$NODE_VERSION" ]; then
        print_error "Node.js is not installed. You can install it via the 'mise' module."
        exit 1
    fi
    
    # Install VSCode extensions
    if [ -f "${SCRIPT_DIR}/vscode-extensions.txt" ]; then
        print_info "Installing VSCode extensions..."
        if ! command_exists code; then
            print_error "VSCode CLI command not found. Please restart your terminal and run this script again."
            exit 1
        fi
        while IFS= read -r extension; do
            code --install-extension "$extension"
        done < "${SCRIPT_DIR}/vscode-extensions.txt"
    fi
else
    print_warning "VSCode is not installed yet. Skipping VSCode settings..."
fi