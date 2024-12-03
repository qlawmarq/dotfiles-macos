#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not macOS!"
    exit 1
fi

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Command Line Tools
xcode-select --install > /dev/null

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

# Install brew
echo "Installing brew..."
if [ ! -f /opt/homebrew/bin/brew ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "brew already installed"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages from Brewfile
echo "Installing packages from Brewfile..."
cp "${SCRIPT_DIR}/.Brewfile" ~/.Brewfile
brew bundle --global

# Setup dotfiles
echo "Setting up dotfiles..."
# Setup .zprofile
cp "${SCRIPT_DIR}/.zprofile" ~/.zprofile

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

# Setup VSCode settings
echo "Setting up VSCode settings..."
if [ -d "/Applications/Visual Studio Code.app" ]; then
    mkdir -p ~/Library/Application\ Support/Code/User
    cp "${SCRIPT_DIR}/vscode/settings.json" ~/Library/Application\ Support/Code/User/settings.json
    
    # Install VSCode extensions
    if [ -f "${SCRIPT_DIR}/vscode-extensions.txt" ]; then
        echo "Installing VSCode extensions..."
        while IFS= read -r extension; do
            code --install-extension "$extension"
        done < "${SCRIPT_DIR}/vscode-extensions.txt"
    fi
else
    echo "VSCode is not installed yet. Skipping VSCode settings..."
fi

# Setup anyenv
echo "Setting up anyenv..."
bash "${SCRIPT_DIR}/anyenv.sh"

# Source profile
source ~/.zprofile

echo "Setup completed! Please restart your terminal."