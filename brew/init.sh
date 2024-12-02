#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

xcode-select --install > /dev/null

# brew
echo "Installing brew..."
if [ ! -f /opt/homebrew/bin/brew ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
	echo "brew already installed"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle --global
