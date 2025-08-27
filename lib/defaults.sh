#!/bin/bash

# ====================
# Shared defaults utilities for macOS settings management
# ====================

# Function to save a specific macOS defaults setting to a file
# Usage: save_defaults_setting "domain" "key" "output_file"
save_defaults_setting() {
    local domain="$1"
    local key="$2"
    local output_file="$3"
    
    value=$(defaults read "$domain" "$key" 2>/dev/null)
    if [ -n "$value" ]; then
        echo "$domain|$key=$value" >> "$output_file"
    fi
}

# Function to apply a defaults setting from domain|key=value format
# Usage: apply_defaults_setting "domain|key=value"
apply_defaults_setting() {
    local setting="$1"
    
    # Parse DOMAIN|KEY=VALUE format
    if [[ "$setting" =~ ^([^|]+)\|([^=]+)=(.*)$ ]]; then
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
        return 0
    else
        echo "Invalid setting format: $setting" >&2
        return 1
    fi
}

# Function to apply defaults settings from a file
# Usage: apply_defaults_from_file "settings_file"
apply_defaults_from_file() {
    local settings_file="$1"
    
    if [ ! -f "$settings_file" ]; then
        echo "Warning: Settings file not found: $settings_file"
        return 1
    fi
    
    # Apply settings from file
    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^#.*$ ]] || [ -z "$line" ]; then
            continue
        fi
        
        # Only process lines that contain the DOMAIN|KEY=VALUE format
        if [[ "$line" =~ ^[^|]+\|[^=]+=.*$ ]]; then
            apply_defaults_setting "$line"
        fi
    done < "$settings_file"
}

# Function to save symbolic hotkey setting (macOS keyboard shortcuts)
# Usage: save_symbolic_hotkey "hotkey_id" "output_file"
save_symbolic_hotkey() {
    local hotkey_id="$1"
    local output_file="$2"
    
    # Check if the hotkey exists and is enabled
    enabled=$(defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys -dict | grep -A 10 "\"$hotkey_id\"" | grep "enabled" | grep -o "[01]")
    
    if [ "$enabled" = "1" ]; then
        # Get the full hotkey definition
        hotkey_data=$(defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys -dict | sed -n "/\"$hotkey_id\"/,/}/p")
        
        if [ -n "$hotkey_data" ]; then
            echo "com.apple.symbolichotkeys|AppleSymbolicHotKeys.$hotkey_id.enabled=$enabled" >> "$output_file"
            
            # Extract parameters if they exist
            parameters=$(echo "$hotkey_data" | grep -A 5 "parameters" | grep -o "[0-9][0-9]*" | tr '\n' ',' | sed 's/,$//')
            if [ -n "$parameters" ]; then
                echo "com.apple.symbolichotkeys|AppleSymbolicHotKeys.$hotkey_id.parameters=$parameters" >> "$output_file"
            fi
        fi
    elif [ "$enabled" = "0" ]; then
        echo "com.apple.symbolichotkeys|AppleSymbolicHotKeys.$hotkey_id.enabled=$enabled" >> "$output_file"
    fi
}

# Function to apply symbolic hotkey setting
# Usage: apply_symbolic_hotkey "hotkey_id" "enabled" ["parameters"]
apply_symbolic_hotkey() {
    local hotkey_id="$1"
    local enabled="$2"
    local parameters="$3"
    
    echo "Setting symbolic hotkey $hotkey_id: enabled=$enabled"
    
    # Set enabled state
    if [ "$enabled" = "1" ]; then
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$hotkey_id" '{enabled = 1;}'
        
        # Set parameters if provided
        if [ -n "$parameters" ]; then
            # Convert comma-separated parameters to array format
            param_array=$(echo "$parameters" | sed 's/,/, /g')
            defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$hotkey_id" "{enabled = 1; value = {parameters = ($param_array); type = standard;};}"
        fi
    else
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$hotkey_id" '{enabled = 0;}'
    fi
}

# Function to save NSUserKeyEquivalents (custom app shortcuts)
# Usage: save_app_shortcuts "domain" "output_file"
save_app_shortcuts() {
    local domain="$1"
    local output_file="$2"
    local domain_name="${3:-$1}"
    
    # Read NSUserKeyEquivalents for the domain
    shortcuts=$(defaults read "$domain" NSUserKeyEquivalents 2>/dev/null || echo "{}")
    
    if [ "$shortcuts" != "{}" ] && [ "$shortcuts" != "" ]; then
        echo "# Shortcuts for $domain_name" >> "$output_file"
        
        # Parse the shortcuts dictionary
        echo "$shortcuts" | grep -E '^\s*".*"\s*=\s*".*";' | while IFS= read -r line; do
            # Extract menu item and shortcut
            menu_item=$(echo "$line" | sed -E 's/^\s*"(.*)"\s*=\s*".*";\s*$/\1/')
            shortcut=$(echo "$line" | sed -E 's/^\s*".*"\s*=\s*"(.*)";\s*$/\1/')
            
            if [ -n "$menu_item" ] && [ -n "$shortcut" ]; then
                echo "$domain|$menu_item=$shortcut" >> "$output_file"
            fi
        done
        echo "" >> "$output_file"
    fi
}

# Function to apply custom app shortcut
# Usage: apply_app_shortcut "domain" "menu_item" "shortcut"
apply_app_shortcut() {
    local domain="$1"
    local menu_item="$2"
    local shortcut="$3"
    
    echo "Setting shortcut for $domain: $menu_item = $shortcut"
    
    if [ "$domain" = "NSGlobalDomain" ]; then
        # Global shortcut
        defaults write -g NSUserKeyEquivalents -dict-add "$menu_item" "$shortcut"
    else
        # App-specific shortcut
        defaults write "$domain" NSUserKeyEquivalents -dict-add "$menu_item" "$shortcut"
    fi
}