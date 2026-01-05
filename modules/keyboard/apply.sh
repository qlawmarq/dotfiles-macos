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

echo "Setting up Keyboard configurations..."

# 1. Modifier key mappings info (manual configuration required)
echo ""
echo "Note: Modifier key mappings (Cmd/Ctrl swap) require manual configuration."
echo "      System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys"
echo ""

# 2. Setup macOS keyboard shortcuts
echo "Configuring macOS keyboard shortcuts..."

# IMPLEMENTATION NOTE:
# We use a hybrid approach for keyboard shortcuts management:
# 1. System shortcuts (symbolic hotkeys) -> Full XML import for reliability  
# 2. Application shortcuts (NSUserKeyEquivalents) -> Selective text-based import

# Import ALL system keyboard shortcuts from XML export
SHORTCUTS_XML="$SCRIPT_DIR/keyboard-shortcuts.xml"
if [ -f "$SHORTCUTS_XML" ]; then
    echo "Importing system keyboard shortcuts from XML..."
    apply_all_symbolic_hotkeys_xml "$SHORTCUTS_XML"
else
    echo "Warning: keyboard-shortcuts.xml not found. System shortcuts not restored."
    echo "Run backup.sh first to capture current shortcuts."
fi

# Apply application-specific keyboard shortcuts from text file
SETTINGS_FILE="$SCRIPT_DIR/keyboard-settings.txt"
if [ -f "$SETTINGS_FILE" ]; then
    echo "Applying application keyboard shortcuts..."
    apply_defaults_from_file "$SETTINGS_FILE"
    echo "✓ Application shortcuts applied"
else
    echo "Warning: keyboard-settings.txt not found. Application shortcuts not restored."
fi

# 3. Activate settings without requiring logout
echo "Activating keyboard settings..."
if [ -f "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings" ]; then
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
    echo "✓ Settings activated"
else
    echo "Note: Settings will take effect after logout/login or restart"
fi

echo "✓ Keyboard configuration setup completed"
echo ""
echo "Note: Some changes may require a logout/login to take full effect."