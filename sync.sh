#!/bin/bash

# 共通ユーティリティを読み込む
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
else
    echo "Error: utils.sh not found at $SCRIPT_DIR/lib/utils.sh"
    exit 1
fi

check_macos

# Source menu functions
if [ -f "$SCRIPT_DIR/lib/menu.sh" ]; then
    source "$SCRIPT_DIR/lib/menu.sh"
else
    echo "Error: menu.sh not found at $SCRIPT_DIR/lib/menu.sh"
    exit 1
fi

# List all available sync modules
MODULES=()
MODULES_DIR="$SCRIPT_DIR/modules"

for dir in "$MODULES_DIR"/*; do
    [ -d "$dir" ] || continue
    module_name="$(basename "$dir")"
    # sync.shが存在するモジュールのみ対象
    if [ -f "$dir/sync.sh" ]; then
        MODULES+=("$module_name")
    fi
done

if [ ${#MODULES[@]} -eq 0 ]; then
    print_error "No sync modules found in $MODULES_DIR. Exiting."
    exit 1
fi

# Select which modules to sync
select_modules "${MODULES[@]}"

# No modules selected
if [ -z "$SELECTED_MODULE_INDICES" ]; then
    print_warning "No modules selected. Exiting."
    exit 0
fi

# Process selected modules
print_info "Starting selected module sync..."

for idx in $SELECTED_MODULE_INDICES; do
    module="${MODULES[$idx]}"
    print_info "Syncing $module..."
    if [ -f "$MODULES_DIR/$module/sync.sh" ]; then
        bash "$MODULES_DIR/$module/sync.sh"
        if [ $? -eq 0 ]; then
            print_success "$module sync completed"
        else
            print_error "$module sync failed"
        fi
    else
        print_error "Sync script for $module not found at $MODULES_DIR/$module/sync.sh"
    fi
    echo ""
done

print_success "All configurations have been synced!"