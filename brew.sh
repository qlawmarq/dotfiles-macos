#!/bin/bash

# brew
echo "Installing brew..."
if [ ! -f /opt/homebrew/bin/brew ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
	echo "brew already installed"
fi
echo "done"

brew install git
brew install anyenv
brew install --cask google-chrome
brew install --cask docker
brew install --cask visual-studio-code
brew install --cask miniconda
brew install --cask google-cloud-sdk
brew install --cask spotify