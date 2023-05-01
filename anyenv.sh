#!/bin/bash

echo 'eval "$(anyenv init -)"' >> ~/.zshrc
anyenv install --init
# anyenv install pyenv
anyenv install nodenv
anyenv install goenv