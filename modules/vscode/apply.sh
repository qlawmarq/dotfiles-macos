#!/bin/bash

# ====================
# VS Code setup script
# ====================

# Read common utils
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ -f "$DOTFILES_DIR/lib/utils.sh" ]; then
    source "$DOTFILES_DIR/lib/utils.sh"
else
    echo "Error: utils.sh not found at $DOTFILES_DIR/lib/utils.sh"
    exit 1
fi

# Source menu functions
if [ -f "$DOTFILES_DIR/lib/menu.sh" ]; then
    source "$DOTFILES_DIR/lib/menu.sh"
else
    echo "Error: menu.sh not found at $DOTFILES_DIR/lib/menu.sh"
    exit 1
fi

check_macos

# Print header
print_info "VS Code Setup"
echo "================="

# Check if VS Code is installed
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
    print_warning "VS Code is not installed. Please install VS Code first via brew module."
    exit 1
fi

# Check if code CLI is available
if ! command_exists code; then
    print_error "VS Code CLI command not found. Please ensure VS Code is in PATH."
    print_info "You may need to run 'Shell Command: Install code command in PATH' from VS Code."
    exit 1
fi

# Setup VS Code settings
print_info "Setting up VS Code settings..."
mkdir -p ~/Library/Application\ Support/Code/User

if [ -f "${SCRIPT_DIR}/settings.json" ]; then
    cp "${SCRIPT_DIR}/settings.json" ~/Library/Application\ Support/Code/User/settings.json
    print_success "VS Code settings applied"
fi

# Install VS Code extensions
EXTENSIONS_FILE="${SCRIPT_DIR}/vscode-extensions.txt"
if [ ! -f "$EXTENSIONS_FILE" ]; then
    print_error "Extensions file not found: $EXTENSIONS_FILE"
    exit 1
fi

# Read extensions into array
extensions=()
while IFS= read -r line; do
    # Skip empty lines and comments
    if [ -n "$line" ] && [[ ! "$line" =~ ^# ]]; then
        extensions+=("$line")
    fi
done < "$EXTENSIONS_FILE"

if [ ${#extensions[@]} -eq 0 ]; then
    print_warning "No extensions found in $EXTENSIONS_FILE"
    exit 0
fi

# Let user select extensions
print_info "Selecting VS Code extensions..."
smart_select_items "Select VS Code extensions to install" "${extensions[@]}"

if [ -z "$SELECTED_ITEMS" ]; then
    print_warning "No extensions selected for installation"
    exit 0
fi

# Confirm installation
print_info "Selected extensions:"
for ext in $SELECTED_ITEMS; do
    echo "  - $ext"
done

if confirm "Do you want to install the selected extensions?"; then
    print_info "Installing VS Code extensions..."
    for ext in $SELECTED_ITEMS; do
        print_info "Installing $ext..."
        if code --install-extension "$ext"; then
            print_success "Installed: $ext"
        else
            print_warning "Failed to install: $ext"
        fi
    done
    print_success "VS Code extension installation completed"
else
    print_info "Installation cancelled"
fi

print_success "VS Code setup completed"
