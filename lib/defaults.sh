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

# DEPRECATED: Individual symbolic hotkey management approach
# 
# IMPLEMENTATION DECISION HISTORY (2025-08-27):
# =============================================
# 
# After extensive investigation, we discovered that managing macOS symbolic hotkeys 
# (system keyboard shortcuts) on an individual basis is fundamentally flawed for 
# several critical reasons:
#
# 1. COMPLEX DATA STRUCTURES:
#    - AppleSymbolicHotKeys contains nested dictionaries with multiple layers
#    - Each hotkey has: enabled (bool), value.parameters (array), value.type (string)
#    - Parameters are encoded as integer arrays with undocumented meanings
#    - Example: key 60 (Input Source switching) = parameters: (96, 50, 524288)
#
# 2. PARSING LIMITATIONS:
#    - defaults command doesn't support reading individual nested keys
#    - grep/sed parsing of complex plist structures is unreliable
#    - Manual parsing fails with special characters and formatting variations
#
# 3. MISSING CRITICAL SHORTCUTS:
#    - Input Source switching (key 60) was not being detected/saved
#    - Mission Control variants (keys 32, 34, etc.) have complex relationships
#    - Total of 37 different symbolic hotkey IDs exist in the system
#
# 4. MAINTENANCE OVERHEAD:
#    - Would require maintaining a complete mapping of all 37 hotkey IDs
#    - Apple can add new shortcuts in OS updates without documentation
#    - Each new shortcut would need reverse engineering
#
# SELECTED SOLUTION: XML Full Export/Import
# ========================================
#
# We chose to use Apple's native export/import mechanism:
# - defaults export com.apple.symbolichotkeys file.xml
# - defaults import com.apple.symbolichotkeys file.xml
#
# ADVANTAGES:
# - 100% compatibility: Uses Apple's official APIs
# - Complete coverage: Captures ALL shortcuts including future additions
# - Reliability: No custom parsing of complex data structures  
# - Atomicity: Import/export operations are atomic
# - Future-proof: Works with any macOS version/shortcuts Apple adds
#
# TRADE-OFFS:
# - Larger file size (425 lines XML vs ~10 lines text)
# - Lower human readability (XML format vs KEY=VALUE)
# - Less granular control (all-or-nothing approach)
#
# CONCLUSION:
# For system-level keyboard shortcuts, reliability and completeness outweigh 
# file size and readability concerns. This ensures critical shortcuts like
# Input Source switching are never missed.
#
# Function to save symbolic hotkey setting (macOS keyboard shortcuts)
# Usage: save_symbolic_hotkey "hotkey_id" "output_file"
# NOTE: This function is DEPRECATED - use save_all_symbolic_hotkeys_xml() instead
save_symbolic_hotkey() {
    local hotkey_id="$1"
    local output_file="$2"
    
    # DEPRECATED: This approach is unreliable for complex symbolic hotkeys
    # See detailed explanation above for why XML export is preferred
    echo "# WARNING: Individual symbolic hotkey saving is deprecated" >> "$output_file"
    echo "# Use save_all_symbolic_hotkeys_xml() for complete coverage" >> "$output_file"
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

# Function to save ALL symbolic hotkeys using XML export (RECOMMENDED APPROACH)
# Usage: save_all_symbolic_hotkeys_xml "output_xml_file"
#
# WHY XML EXPORT IS USED:
# This function implements the recommended approach for managing macOS symbolic hotkeys.
# Unlike individual key management, this captures ALL 37+ system keyboard shortcuts
# including critical ones like Input Source switching (key 60) that were previously missed.
save_all_symbolic_hotkeys_xml() {
    local output_file="$1"
    
    echo "Exporting all symbolic hotkeys to XML format..."
    # Use '-' to export to stdout and redirect to ensure XML format (not binary plist)
    defaults export com.apple.symbolichotkeys - > "$output_file"
    
    if [ $? -eq 0 ] && [ -s "$output_file" ]; then
        # Verify it's XML format by checking for XML header
        if head -1 "$output_file" | grep -q "<?xml"; then
            echo "✓ Successfully exported $(grep -c '<key>' "$output_file" 2>/dev/null || echo 'all') symbolic hotkeys to XML"
        else
            echo "✗ Export failed: file is not in XML format" >&2
            return 1
        fi
    else
        echo "✗ Failed to export symbolic hotkeys" >&2
        return 1
    fi
}

# Function to restore ALL symbolic hotkeys from XML export
# Usage: apply_all_symbolic_hotkeys_xml "input_xml_file" 
#
# IMPORTANT: This function replaces ALL symbolic hotkeys with the imported configuration.
# Any shortcuts modified through System Settings after the export will be overwritten.
apply_all_symbolic_hotkeys_xml() {
    local input_file="$1"
    
    if [ ! -f "$input_file" ]; then
        echo "Warning: Symbolic hotkeys file not found: $input_file" >&2
        return 1
    fi
    
    echo "Importing all symbolic hotkeys from XML..."
    defaults import com.apple.symbolichotkeys "$input_file"
    
    if [ $? -eq 0 ]; then
        echo "✓ Successfully imported symbolic hotkeys"
        
        # Activate settings to take effect immediately without logout
        if [ -f "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings" ]; then
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
        fi
    else
        echo "✗ Failed to import symbolic hotkeys" >&2
        return 1
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