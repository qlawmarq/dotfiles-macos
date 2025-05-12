#!/bin/bash

# ====================
# Main dotfiles initialization script
# ====================

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source menu functions
if [ -f "$SCRIPT_DIR/lib/menu.sh" ]; then
    source "$SCRIPT_DIR/lib/menu.sh"
else
    echo "Error: menu.sh not found at $SCRIPT_DIR/lib/menu.sh"
    exit 1
fi

# Check if running on macOS
if [ "$(uname)" != "Darwin" ]; then
    print_error "Not macOS!"
    exit 1
fi

# Print welcome message
clear
echo "===================================="
echo "     MacOS Dotfiles Setup Tool      "
echo "===================================="
echo ""

# List all available setup modules
MODULES=()
MODULES_DIR="$SCRIPT_DIR/modules"

# modulesディレクトリ配下のサブディレクトリを列挙
for dir in "$MODULES_DIR"/*; do
    [ -d "$dir" ] || continue
    module_name="$(basename "$dir")"
    MODULES+=("$module_name")
done

if [ ${#MODULES[@]} -eq 0 ]; then
    print_error "No modules found in $MODULES_DIR. Exiting."
    exit 1
fi

# Select which modules to install
select_modules "${MODULES[@]}"

# No modules selected
if [ -z "$SELECTED_MODULE_INDICES" ]; then
    print_warning "No modules selected. Exiting."
    exit 0
fi

# Process selected modules
print_info "Starting selected module installations..."

for idx in $SELECTED_MODULE_INDICES; do
    module="${MODULES[$idx]}"
    print_info "Setting up $module..."
    # Check if module init script exists
    if [ -f "$MODULES_DIR/$module/init.sh" ]; then
        bash "$MODULES_DIR/$module/init.sh"
        if [ $? -eq 0 ]; then
            print_success "$module setup completed"
        else
            print_error "$module setup failed"
        fi
    else
        print_error "Setup script for $module not found at $MODULES_DIR/$module/init.sh"
    fi
    echo ""
done

# Source profile to apply changes
if [ -f ~/.zprofile ]; then
    print_info "Sourcing ~/.zprofile to apply changes"
    source ~/.zprofile
fi

print_success "Setup completed! Please restart your terminal."
exit 0