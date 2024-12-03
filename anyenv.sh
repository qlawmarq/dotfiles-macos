#!/bin/bash

echo 'eval "$(anyenv init -)"' >> ~/.zshrc
anyenv install --init

# install anyenv update
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

# install language version managers
anyenv install pyenv
anyenv install nodenv
anyenv install goenv

# reload environment
exec $SHELL -l