#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Setup dotfiles
echo "Setting up dotfiles..."

# Setup .zprofile
cp "${SCRIPT_DIR}/.zprofile" ~/.zprofile

# Setup .zshrc
cp "${SCRIPT_DIR}/.zshrc" ~/.zshrc
