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

echo "Starting Cursor editor installation..."

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

# Cursor configuration
if [ -d "/Applications/Cursor.app" ]; then
    # Create MCP directory if not exists
    print_info "Setting up MCP directory..."
    mkdir -p "$HOME/Codes"

    print_info "Setting up Cursor configuration..."
    CURSOR_CONFIG_DIR=~/.cursor
    mkdir -p "$CURSOR_CONFIG_DIR"
    
    # Get current versions from mise
    NODE_VERSION=$(mise current node | awk '{print $1}')
    
    # Check if runtimes are installed
    if [ -z "$NODE_VERSION" ]; then
        print_error "Node.js is not installed."
        exit 1
    fi
    
    # Try to get tokens from existing config file
    CONFIG_FILE="$CURSOR_CONFIG_DIR/mcp.json"
    if [ -f "$CONFIG_FILE" ]; then
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
    print_info "Updating configuration with Node.js $NODE_VERSION..."
    
    TMP_CONFIG=$(mktemp)
    cat "${SCRIPT_DIR}/mcp.json" | \
        sed -e "s|\$NODE_VERSION|$NODE_VERSION|g" > "$TMP_CONFIG"
    
    sed -e "s|\$HOME|$HOME|g" \
        -e "s|\$GITHUB_TOKEN|$GITHUB_TOKEN|g" \
        "$TMP_CONFIG" > "$CURSOR_CONFIG_DIR/mcp.json"
    
    rm "$TMP_CONFIG"
    
    print_success "Cursor configuration updated successfully"
else
    print_warning "Cursor is not installed..."
fi 