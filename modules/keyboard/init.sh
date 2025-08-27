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
        echo "Warning: karabiner.json not found. Run sync.sh first."
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

# Apply keyboard settings from file
SETTINGS_FILE="$SCRIPT_DIR/keyboard-settings.txt"
if [ -f "$SETTINGS_FILE" ]; then
    echo "Applying keyboard settings..."
    
    # Apply settings from file
    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^#.*$ ]] || [ -z "$line" ]; then
            continue
        fi
        
        # Handle different types of settings
        if [[ "$line" =~ ^com\.apple\.symbolichotkeys\|AppleSymbolicHotKeys\.([0-9]+)\.(enabled|parameters)=(.*)$ ]]; then
            # Symbolic hotkey setting
            hotkey_id="${BASH_REMATCH[1]}"
            property="${BASH_REMATCH[2]}"
            value="${BASH_REMATCH[3]}"
            
            if [ "$property" = "enabled" ]; then
                # For now, we'll handle basic enabled/disabled state
                echo "Setting symbolic hotkey $hotkey_id: enabled=$value"
                if [ "$value" = "1" ]; then
                    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$hotkey_id" '{enabled = 1;}'
                else
                    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$hotkey_id" '{enabled = 0;}'
                fi
            fi
        elif [[ "$line" =~ ^([^|]+)\|([^=]+)=(.*)$ ]]; then
            # Regular defaults setting or app shortcut
            domain="${BASH_REMATCH[1]}"
            key="${BASH_REMATCH[2]}"
            value="${BASH_REMATCH[3]}"
            
            # Check if this is an app shortcut (contains menu item-like text)
            if [[ "$key" =~ [[:space:]] ]] || [[ "$value" =~ ^[@~^$] ]]; then
                # This looks like an app shortcut
                apply_app_shortcut "$domain" "$key" "$value"
            else
                # Regular defaults setting
                apply_defaults_setting "$line"
            fi
        fi
    done < "$SETTINGS_FILE"
    
    echo "✓ Keyboard settings applied"
else
    echo "Warning: keyboard-settings.txt not found. Run sync.sh first."
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