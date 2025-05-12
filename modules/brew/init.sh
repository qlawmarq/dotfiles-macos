#!/bin/bash

# ====================
# Homebrew initialization script
# ====================

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source menu functions
if [ -f "$DOTFILES_DIR/lib/menu.sh" ]; then
    source "$DOTFILES_DIR/lib/menu.sh"
else
    echo "Error: menu.sh not found at $DOTFILES_DIR/lib/menu.sh"
    exit 1
fi

# Check if running on macOS
if [ "$(uname)" != "Darwin" ]; then
    print_error "Not macOS!"
    exit 1
fi

# Print header
print_info "Homebrew Setup"
echo "================="

# Install brew if needed
if ! command_exists "brew"; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    if [ $? -ne 0 ]; then
        print_error "Failed to install Homebrew"
        exit 1
    fi
    print_success "Homebrew installed successfully"
else
    print_info "Homebrew is already installed"
fi

# Make sure brew is in PATH
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Parse Brewfile and let user select packages
print_info "Processing Brewfile selections..."

# Check if Brewfile exists
BREWFILE_PATH="$SCRIPT_DIR/.Brewfile"
if [ ! -f "$BREWFILE_PATH" ]; then
    print_error "Brewfile not found at $BREWFILE_PATH"
    exit 1
fi

# Select packages from Brewfile
select_from_brewfile "Homebrew Package Selection" "$BREWFILE_PATH"

# Check if anything was selected
if [ -z "$SELECTED_TAPS$SELECTED_BREWS$SELECTED_CASKS$SELECTED_VSCODE" ]; then
    print_warning "No packages selected for installation"
    exit 0
fi

# Create temporary Brewfile with selected packages
TEMP_BREWFILE=$(mktemp)
build_brewfile "$TEMP_BREWFILE" "$SELECTED_TAPS" "$SELECTED_BREWS" "$SELECTED_CASKS" "$SELECTED_VSCODE"

# Display selected packages
print_info "Selected packages for installation:"
cat "$TEMP_BREWFILE"

# Confirm installation
if confirm "Do you want to install the selected packages?"; then
    print_info "Installing selected packages..."
    brew bundle --file="$TEMP_BREWFILE"
    
    if [ $? -eq 0 ]; then
        print_success "Homebrew packages installed successfully"
    else
        print_error "Failed to install some Homebrew packages"
        exit 1
    fi
else
    print_info "Installation cancelled"
    exit 0
fi

# Clean up
rm -f "$TEMP_BREWFILE"

print_success "Homebrew setup completed"