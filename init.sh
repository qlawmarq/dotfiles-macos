#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Setup Homebrew
echo "Setting up Homebrew..."
bash "${SCRIPT_DIR}/brew/init.sh"

# Setup git
echo "Setting up git..."
bash "${SCRIPT_DIR}/git/init.sh"

# Setup VSCode
echo "Setting up VSCode..."
bash "${SCRIPT_DIR}/editor/init.sh"

# Setup mise and runtimes
echo "Setting up mise and runtimes..."
bash "${SCRIPT_DIR}/mise/init.sh"

# Setup Claude Desktop
echo "Setting up Claude Desktop..."
bash "${SCRIPT_DIR}/claude/init.sh"

# Setup dotfiles
echo "Setting up dotfiles..."
bash "${SCRIPT_DIR}/dotfiles/init.sh"

# Source profile
source ~/.zprofile

echo "Setup completed! Please restart your terminal."