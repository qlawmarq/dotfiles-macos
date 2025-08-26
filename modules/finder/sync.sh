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

echo "Syncing Finder settings..."

# Export current Finder settings in XML format for readability
if defaults export com.apple.finder - 2>/dev/null | plutil -convert xml1 - -o "$SCRIPT_DIR/com.apple.finder.plist"; then
    echo "# Exported com.apple.finder settings"
else
    echo "# No com.apple.finder settings found" > "$SCRIPT_DIR/com.apple.finder.plist"
fi

if defaults export com.apple.desktopservices - 2>/dev/null | plutil -convert xml1 - -o "$SCRIPT_DIR/com.apple.desktopservices.plist"; then
    echo "# Exported com.apple.desktopservices settings" 
else
    echo "# No com.apple.desktopservices settings found" > "$SCRIPT_DIR/com.apple.desktopservices.plist"
fi

echo "✓ Finder settings synced to plist files"