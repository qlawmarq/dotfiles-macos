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

# Setup Homebrew
if confirm "Would you like to install Homebrew?"; then
    echo "Setting up Homebrew..."
    bash "${SCRIPT_DIR}/brew/init.sh"
fi

# Setup git
if confirm "Would you like to setup git?"; then
    echo "Setting up git..."
    bash "${SCRIPT_DIR}/git/init.sh"
fi

# Setup VSCode
if confirm "Would you like to setup VSCode?"; then
    echo "Setting up VSCode..."
    bash "${SCRIPT_DIR}/editor/init.sh"
fi

# Setup mise and runtimes
if confirm "Would you like to setup mise and runtimes?"; then
    echo "Setting up mise and runtimes..."
    bash "${SCRIPT_DIR}/mise/init.sh"
fi

# Setup Claude Desktop
if confirm "Would you like to setup Claude Desktop?"; then
    echo "Setting up Claude Desktop..."
    bash "${SCRIPT_DIR}/claude/init.sh"
fi

# Setup dotfiles
if confirm "Would you like to setup dotfiles?"; then
    echo "Setting up dotfiles..."
    bash "${SCRIPT_DIR}/dotfiles/init.sh"
fi

# Source profile
source ~/.zprofile

# restart terminal
echo "Setup completed! Please restart your terminal."
exit 0
