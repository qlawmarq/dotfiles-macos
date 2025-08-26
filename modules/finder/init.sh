#!/bin/bash

# ====================
# Finder initialization script
# Apply saved Finder settings from configuration file
# ====================

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load utilities
if [ -f "$DOTFILES_DIR/lib/utils.sh" ]; then
    source "$DOTFILES_DIR/lib/utils.sh"
else
    echo "Error: utils.sh not found at $DOTFILES_DIR/lib/utils.sh"
    exit 1
fi

check_macos

echo "Setting up Finder..."

# Check if settings file exists
SETTINGS_FILE="$SCRIPT_DIR/finder-settings.sh"
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Warning: No finder-settings.sh found."
    echo "Run sync.sh first to capture current settings."
    exit 1
fi

# Load settings
source "$SETTINGS_FILE"

# Apply each setting
echo "Applying Finder settings..."
for key in "${!FINDER_SETTINGS[@]}"; do
    # Split domain|key
    IFS='|' read -r domain setting_key <<< "$key"
    value="${FINDER_SETTINGS[$key]}"
    
    # Skip empty values
    if [ -z "$value" ]; then
        continue
    fi
    
    echo "Setting $domain $setting_key = $value"
    
    # Convert true/false to boolean for defaults command
    if [ "$value" = "true" ]; then
        defaults write "$domain" "$setting_key" -bool true
    elif [ "$value" = "false" ]; then
        defaults write "$domain" "$setting_key" -bool false
    elif [[ "$value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        # Check if it's a number (integer or float)
        if [[ "$value" =~ \. ]]; then
            defaults write "$domain" "$setting_key" -float "$value"
        else
            defaults write "$domain" "$setting_key" -int "$value"
        fi
    else
        # String value
        defaults write "$domain" "$setting_key" -string "$value"
    fi
done

# Restart Finder to apply changes
echo "Restarting Finder to apply changes..."
killall Finder

echo "✓ Finder settings applied"