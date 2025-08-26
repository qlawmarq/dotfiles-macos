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

# Check if plist files exist
if [ ! -f "$SCRIPT_DIR/com.apple.finder.plist" ]; then
    echo "Warning: No com.apple.finder.plist found."
    echo "Run sync.sh first to capture current settings."
    exit 1
fi

echo "Applying Finder settings..."

# Import settings from plist files
if [ -f "$SCRIPT_DIR/com.apple.finder.plist" ] && [ -s "$SCRIPT_DIR/com.apple.finder.plist" ]; then
    if ! grep -q "^#" "$SCRIPT_DIR/com.apple.finder.plist"; then
        defaults import com.apple.finder "$SCRIPT_DIR/com.apple.finder.plist"
        echo "✓ Applied com.apple.finder settings"
    fi
fi

if [ -f "$SCRIPT_DIR/com.apple.desktopservices.plist" ] && [ -s "$SCRIPT_DIR/com.apple.desktopservices.plist" ]; then
    if ! grep -q "^#" "$SCRIPT_DIR/com.apple.desktopservices.plist"; then
        defaults import com.apple.desktopservices "$SCRIPT_DIR/com.apple.desktopservices.plist"
        echo "✓ Applied com.apple.desktopservices settings"
    fi
fi

# Restart Finder
echo "Restarting Finder..."
killall Finder

echo "✓ Finder settings applied"