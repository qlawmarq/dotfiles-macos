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
bash "${SCRIPT_DIR}/brew.sh"

# Setup dotfiles
echo "Setting up dotfiles..."
# Setup .zprofile
cp "${SCRIPT_DIR}/.zprofile" ~/.zprofile


# Setup git
echo "Setting up git..."
bash "${SCRIPT_DIR}/git.sh"

# Setup VSCode
echo "Setting up VSCode..."
bash "${SCRIPT_DIR}/vscode.sh"

# Setup Claude Desktop
echo "Setting up Claude Desktop..."
bash "${SCRIPT_DIR}/claude.sh"

# Setup anyenv
echo "Setting up anyenv..."
bash "${SCRIPT_DIR}/anyenv.sh"

# Source profile
source ~/.zprofile

# install latest stable Node.js
latest_stable=$(nodenv install -l | grep -v - | grep -v a | tail -1)
nodenv install $latest_stable
nodenv global $latest_stable

echo "Setup completed! Please restart your terminal."