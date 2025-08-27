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

# Load defaults utilities
if [ -f "$DOTFILES_DIR/lib/defaults.sh" ]; then
    source "$DOTFILES_DIR/lib/defaults.sh"
else
    echo "Error: defaults.sh not found at $DOTFILES_DIR/lib/defaults.sh"
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

# Use shared defaults function to apply settings from file
apply_defaults_from_file "$SETTINGS_FILE"

# Restart Finder
echo "Restarting Finder..."
killall Finder

echo "✓ Finder settings applied"