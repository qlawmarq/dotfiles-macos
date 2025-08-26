#!/bin/bash

# Load utils
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ -f "$DOTFILES_DIR/lib/utils.sh" ]; then
    source "$DOTFILES_DIR/lib/utils.sh"
else
    echo "Error: utils.sh not found at $DOTFILES_DIR/lib/utils.sh"
    exit 1
fi

check_macos

echo "Setting up Finder..."

# Check if settings file exists
SETTINGS_FILE="$SCRIPT_DIR/finder-settings.txt"
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Warning: No finder-settings.txt found."
    echo "Run sync.sh first to capture current settings."
    exit 1
fi

echo "Applying Finder settings..."

# Apply settings from file
while IFS= read -r line; do
    # Skip comments and empty lines
    if [[ "$line" =~ ^#.*$ ]] || [ -z "$line" ]; then
        continue
    fi
    
    # Parse DOMAIN|KEY=VALUE format
    if [[ "$line" =~ ^([^|]+)\|([^=]+)=(.*)$ ]]; then
        domain="${BASH_REMATCH[1]}"
        key="${BASH_REMATCH[2]}"
        value="${BASH_REMATCH[3]}"
        
        echo "Setting $domain $key = $value"
        
        # Apply setting using defaults
        if [ "$value" = "1" ]; then
            defaults write "$domain" "$key" -bool true
        elif [ "$value" = "0" ]; then
            defaults write "$domain" "$key" -bool false
        elif [[ "$value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            # Numeric value
            if [[ "$value" =~ \. ]]; then
                defaults write "$domain" "$key" -float "$value"
            else
                defaults write "$domain" "$key" -int "$value"
            fi
        else
            # String value
            defaults write "$domain" "$key" -string "$value"
        fi
    fi
done < "$SETTINGS_FILE"

# Restart Finder
echo "Restarting Finder..."
killall Finder

echo "✓ Finder settings applied"