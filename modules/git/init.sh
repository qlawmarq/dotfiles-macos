#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Setup SSH for GitHub if not exists
setup_github_ssh() {
    local email="$1"
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        echo "Setting up SSH key for GitHub..."
        ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""
        
        # Create or update SSH config
        if [ ! -f ~/.ssh/config ]; then
            mkdir -p ~/.ssh
            touch ~/.ssh/config
        fi
        
        # Only add GitHub config if it doesn't exist
        if ! grep -q "Host github.com" ~/.ssh/config; then
            cat << EOF >> ~/.ssh/config

Host github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
EOF
        fi
        
        # Start ssh-agent and add key
        eval "$(ssh-agent -s)"
        ssh-add -K ~/.ssh/id_ed25519
        
        # Copy public key to clipboard
        pbcopy < ~/.ssh/id_ed25519.pub
        echo "SSH public key has been copied to clipboard."
        echo "Please add it to your GitHub account: https://github.com/settings/keys"
        echo "Press Enter when you have added the key to GitHub..."
        read -r
    else
        echo "SSH key already exists, skipping GitHub SSH setup..."
    fi
}

# Setup git related files
cp "${SCRIPT_DIR}/.gitconfig" ~/.gitconfig
mkdir -p ~/.config/git
cp "${SCRIPT_DIR}/.config/git/ignore" ~/.config/git/ignore

# Get Git email from .gitconfig for SSH setup
GIT_EMAIL=$(git config --global user.email)
if [ -n "$GIT_EMAIL" ]; then
    setup_github_ssh "$GIT_EMAIL"
else
    echo "No Git email found in .gitconfig. Please enter your GitHub email:"
    read -r GIT_EMAIL
    setup_github_ssh "$GIT_EMAIL"
fi
