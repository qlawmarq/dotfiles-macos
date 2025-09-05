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

# 1. Setup Karabiner-Elements
echo "Configuring Karabiner-Elements..."

# Check if Karabiner-Elements is installed
if [ ! -d "/Applications/Karabiner-Elements.app" ]; then
    echo "Warning: Karabiner-Elements is not installed."
    echo "It should be installed via the brew module."
    if ! confirm "Continue without Karabiner-Elements?"; then
        exit 1
    fi
else
    # Create Karabiner config directory
    KARABINER_CONFIG_DIR="$HOME/.config/karabiner"
    mkdir -p "$KARABINER_CONFIG_DIR"
    mkdir -p "$KARABINER_CONFIG_DIR/assets/complex_modifications"
    
    # Copy Karabiner configuration
    if [ -f "$SCRIPT_DIR/karabiner.json" ]; then
        echo "Applying Karabiner-Elements configuration..."
        cp "$SCRIPT_DIR/karabiner.json" "$KARABINER_CONFIG_DIR/karabiner.json"
        echo "✓ Karabiner configuration applied"
    else
        echo "Warning: karabiner.json not found. Run backup.sh first."
    fi
    
    # Copy complex modifications if they exist
    if [ -d "$SCRIPT_DIR/complex_modifications" ] && [ "$(ls -A "$SCRIPT_DIR/complex_modifications" 2>/dev/null | grep -v '.gitkeep')" ]; then
        echo "Copying complex modifications..."
        find "$SCRIPT_DIR/complex_modifications" -name "*.json" -exec cp {} "$KARABINER_CONFIG_DIR/assets/complex_modifications/" \;
        echo "✓ Complex modifications copied"
    fi
fi

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

# 4. Restart Karabiner-Elements if it's running
if pgrep -f "Karabiner-Elements" > /dev/null; then
    echo "Restarting Karabiner-Elements..."
    osascript -e 'tell application "Karabiner-Elements" to quit' 2>/dev/null || true
    sleep 2
    open -a "Karabiner-Elements" 2>/dev/null || true
    echo "✓ Karabiner-Elements restarted"
fi

echo "✓ Keyboard configuration setup completed"
echo ""
echo "Note: Some changes may require a logout/login to take full effect."