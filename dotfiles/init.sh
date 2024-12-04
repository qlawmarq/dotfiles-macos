#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Setup dotfiles
echo "Setting up dotfiles..."
# Setup .zprofile
cp "${SCRIPT_DIR}/.zprofile" ~/.zprofile