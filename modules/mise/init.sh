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

# check if mise is installed
if ! command_exists mise; then
    print_error "mise could not be found"
    exit 1
fi

# Install Go
if confirm "Would you like to install Go?"; then
    print_info "Installing Go..."
    mise use -g go@latest
    print_success "Go installed"
fi

# Install Python
if confirm "Would you like to install Python? (necessary for Claude Desktop)"; then
    print_info "Installing Python..."
    mise use -g python@latest
    print_success "Python installed"
fi

# Install Node.js
if confirm "Would you like to install Node.js? (necessary for Claude Desktop)"; then
    print_info "Installing Node.js..."
    mise use -g node@lts
    print_success "Node.js installed"
    if confirm "Would you like to install `pnpm`?"; then
        print_info "Installing pnpm..."
        mise use -g pnpm@latest
        print_success "pnpm installed"
    fi
fi

# Source the new environment
mise activate

print_success "Runtime installation completed!"