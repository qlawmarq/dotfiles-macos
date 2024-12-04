#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Command Line Tools
xcode-select --install > /dev/null

# Setup Homebrew
echo "Setting up Homebrew..."
bash "${SCRIPT_DIR}/brew/init.sh"

# Setup git
echo "Setting up git..."
bash "${SCRIPT_DIR}/git/init.sh"

# Setup VSCode
echo "Setting up VSCode..."
bash "${SCRIPT_DIR}/editor/init.sh"

# Setup Claude Desktop
echo "Setting up Claude Desktop..."
bash "${SCRIPT_DIR}/claude/init.sh"

# Setup anyenv
echo "Setting up anyenv..."
bash "${SCRIPT_DIR}/anyenv/init.sh"

# Source profile
source ~/.zprofile

# install latest stable Node.js
latest_stable=$(nodenv install -l | grep -v - | grep -v a | tail -1)
nodenv install $latest_stable
nodenv global $latest_stable

echo "Setup completed! Please restart your terminal."