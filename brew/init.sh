#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install brew
echo "Installing brew..."
if [ ! -f /opt/homebrew/bin/brew ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "brew already installed"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages from Brewfile
echo "Installing packages from Brewfile..."
cp "${SCRIPT_DIR}/.Brewfile" ~/.Brewfile
brew bundle --global