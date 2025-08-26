#!/bin/bash

# ====================
# Finder sync script
# Sync current Finder settings to configuration file
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

echo "Syncing Finder settings..."

# Create settings file
SETTINGS_FILE="$SCRIPT_DIR/finder-settings.sh"

# Write header
cat > "$SETTINGS_FILE" << 'EOF'
#!/bin/bash

# Finder Settings Configuration
# This file contains the current Finder settings
# Generated on: 
EOF
echo "# Generated on: $(date)" >> "$SETTINGS_FILE"

cat >> "$SETTINGS_FILE" << 'EOF'

declare -A FINDER_SETTINGS=(
EOF

# Function to save a setting
save_setting() {
    local domain="$1"
    local key="$2"
    local description="$3"
    
    # Read current value
    value=$(defaults read "$domain" "$key" 2>/dev/null)
    
    # Convert boolean values
    if [ "$value" = "1" ]; then
        value="true"
    elif [ "$value" = "0" ]; then
        value="false"
    fi
    
    # Add comment and setting to file
    echo "    # $description" >> "$SETTINGS_FILE"
    echo "    [\"$domain|$key\"]=\"$value\"" >> "$SETTINGS_FILE"
}

# General Settings
echo "    # General Settings" >> "$SETTINGS_FILE"
save_setting "NSGlobalDomain" "AppleShowAllExtensions" "Show all file extensions"
save_setting "com.apple.finder" "AppleShowAllFiles" "Show hidden files"
save_setting "com.apple.finder" "ShowPathbar" "Show path bar"
save_setting "com.apple.finder" "ShowStatusBar" "Show status bar"
save_setting "com.apple.finder" "_FXSortFoldersFirst" "Keep folders on top when sorting by name"
save_setting "com.apple.finder" "FXEnableExtensionChangeWarning" "File extension change warning"

echo "    " >> "$SETTINGS_FILE"
echo "    # View Settings" >> "$SETTINGS_FILE"
save_setting "com.apple.finder" "FXPreferredViewStyle" "Preferred view style"
save_setting "com.apple.finder" "_FXShowPosixPathInTitle" "Show POSIX path in title"
save_setting "com.apple.finder" "FXDefaultSearchScope" "Default search scope"
save_setting "com.apple.finder" "NewWindowTarget" "New window target"
save_setting "com.apple.finder" "NewWindowTargetPath" "New window target path"

echo "    " >> "$SETTINGS_FILE"
echo "    # Desktop Settings" >> "$SETTINGS_FILE"
save_setting "com.apple.finder" "ShowHardDrivesOnDesktop" "Show hard drives on desktop"
save_setting "com.apple.finder" "ShowExternalHardDrivesOnDesktop" "Show external drives on desktop"
save_setting "com.apple.finder" "ShowMountedServersOnDesktop" "Show mounted servers on desktop"
save_setting "com.apple.finder" "ShowRemovableMediaOnDesktop" "Show removable media on desktop"

echo "    " >> "$SETTINGS_FILE"
echo "    # Network and USB volumes" >> "$SETTINGS_FILE"
save_setting "com.apple.desktopservices" "DSDontWriteNetworkStores" "Disable .DS_Store on network volumes"
save_setting "com.apple.desktopservices" "DSDontWriteUSBStores" "Disable .DS_Store on USB volumes"

echo "    " >> "$SETTINGS_FILE"
echo "    # Other Settings" >> "$SETTINGS_FILE"
save_setting "com.apple.finder" "QuitMenuItem" "Allow quitting Finder"
save_setting "com.apple.finder" "WarnOnEmptyTrash" "Warning before emptying trash"
save_setting "NSGlobalDomain" "com.apple.springing.enabled" "Spring loading for directories"
save_setting "NSGlobalDomain" "com.apple.springing.delay" "Spring loading delay"
save_setting "NSGlobalDomain" "NSNavPanelExpandedStateForSaveMode" "Save panel expanded by default"
save_setting "NSGlobalDomain" "NSNavPanelExpandedStateForSaveMode2" "Save panel expanded by default 2"
save_setting "NSGlobalDomain" "PMPrintingExpandedStateForPrint" "Print panel expanded by default"
save_setting "NSGlobalDomain" "PMPrintingExpandedStateForPrint2" "Print panel expanded by default 2"

# Close array
echo ")" >> "$SETTINGS_FILE"

echo "✓ Finder settings synced to finder-settings.sh"