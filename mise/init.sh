#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# check if mise is installed
if ! command -v mise &> /dev/null; then
    echo "mise could not be found"
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

# Install Go
if confirm "Would you like to install Go?"; then
    echo "Installing Go..."
    mise use -g go@latest
    echo "✓ Go installed"
fi

# Install Python
if confirm "Would you like to install Python? (necessary for Claude Desktop)"; then
    echo "Installing Python..."
    mise use -g python@latest
    echo "✓ Python installed"
fi

# Install Node.js
if confirm "Would you like to install Node.js? (necessary for Claude Desktop)"; then
    echo "Installing Node.js..."
    mise use -g node@lts
    echo "✓ Node.js installed"
    if confirm "Would you like to install `pnpm`?"; then
        echo "Installing pnpm..."
        mise use -g pnpm@latest
        echo "✓ pnpm installed"
    fi
fi

# Source the new environment
mise activate

echo "Runtime installation completed!"