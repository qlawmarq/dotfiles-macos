#!/bin/bash

# ====================
# Claude Desktop initialization script
# ====================

# Function to select from JSON configuration (for Claude)
# Usage: select_from_json "header_message" "json_file" "parent_key"
# Returns: Selected keys in $SELECTED_JSON_KEYS
select_from_json() {
    local header="$1"
    local json_file="$2"
    local parent_key="${3:-mcpServers}"
    
    # Check if jq exists
    if ! command_exists "jq"; then
        print_error "jq is required for JSON parsing but not found"
        return 1
    fi
    
    # Extract keys
    keys=()
    local keys_file=$(mktemp)
    jq -r ".$parent_key | keys[]" "$json_file" > "$keys_file" 2>/dev/null
    
    while IFS= read -r line; do
        keys+=("$line")
    done < "$keys_file"
    rm -f "$keys_file"
    
    # Select items
    smart_select_items "$header" "${keys[@]}"
    SELECTED_JSON_KEYS="$SELECTED_ITEMS"
}

# Function to filter JSON based on selected keys (for Claude)
# Usage: filter_json "input_file" "output_file" "parent_key" "selected_keys"
filter_json() {
    local input="$1"
    local output="$2"
    local parent_key="${3:-mcpServers}"
    local keys="$4"
    
    # Create a new JSON with just the parent object
    echo "{\"$parent_key\":{}}" > "$output"
    
    # Add each selected key
    for key in $keys; do
        local temp_file=$(mktemp)
        value=$(jq ".$parent_key.\"$key\"" "$input")
        jq --arg key "$key" --argjson value "$value" ".$parent_key[\$key] = \$value" "$output" > "$temp_file"
        mv "$temp_file" "$output"
    done
}

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load utils
if [ -f "$DOTFILES_DIR/lib/utils.sh" ]; then
    source "$DOTFILES_DIR/lib/utils.sh"
else
    echo "Error: utils.sh not found at $DOTFILES_DIR/lib/utils.sh"
    exit 1
fi

check_macos

# Source menu functions
if [ -f "$DOTFILES_DIR/lib/menu.sh" ]; then
    source "$DOTFILES_DIR/lib/menu.sh"
else
    echo "Error: menu.sh not found at $DOTFILES_DIR/lib/menu.sh"
    exit 1
fi

# Print header
print_info "Claude Desktop Setup"
echo "======================"

# Check for required dependencies
print_info "Checking dependencies..."

# Check if mise is installed
if ! command_exists "mise"; then
    print_error "mise is not installed. Please run the mise setup first."
    exit 1
fi

# Check if uv is installed
if ! command_exists "uv"; then
    print_error "uv is not installed. Please install Node.js first. 'mise use uv@latest'"
    exit 1
fi

# Check if node is installed
if ! command_exists "node"; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if Claude Desktop is installed
if [ ! -d "/Applications/Claude.app" ]; then
    print_error "Claude Desktop is not installed. Please install it first."
    exit 1
fi

# Create MCP directory if not exists
print_info "Setting up MCP directory..."
mkdir -p "$HOME/Codes"

# Create Claude config directory
print_info "Setting up Claude Desktop configuration..."
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
mkdir -p "$CLAUDE_CONFIG_DIR"

# Get current versions from mise
PYTHON_VERSION=$(mise current python | awk '{print $1}')
NODE_VERSION=$(mise current node | awk '{print $1}')

# Check if runtimes are installed
if [ -z "$PYTHON_VERSION" ]; then
    print_error "Python is not installed through mise."
    exit 1
fi

if [ -z "$NODE_VERSION" ]; then
    print_error "Node.js is not installed through mise."
    exit 1
fi

# Try to get tokens from existing config file
CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
GITHUB_TOKEN=""

if [ -f "$CONFIG_FILE" ]; then
    # Extract GitHub token if present
    EXTRACTED_GITHUB_TOKEN=$(grep -o '"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    if [ -n "$EXTRACTED_GITHUB_TOKEN" ]; then
        GITHUB_TOKEN="$EXTRACTED_GITHUB_TOKEN"
    fi
fi

# Ask for GitHub token if not already set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Please enter your GitHub Personal Access Token: (https://github.com/settings/personal-access-tokens)"
    read -r GITHUB_TOKEN
fi

# Parse configuration template and allow selection
CONFIG_TEMPLATE="$SCRIPT_DIR/claude_desktop_config.json"
if [ ! -f "$CONFIG_TEMPLATE" ]; then
    print_error "Claude Desktop configuration template not found at $CONFIG_TEMPLATE"
    exit 1
fi

# Check if jq exists for JSON manipulation
if command_exists "jq"; then
    print_info "Selecting MCP servers to configure..."
    # Select MCP servers from configuration
    select_from_json "Select MCP servers to configure" "$CONFIG_TEMPLATE" "mcpServers"
    
    if [ -n "$SELECTED_JSON_KEYS" ]; then
        # Create filtered JSON with only selected servers
        TMP_JSON=$(mktemp)
        filter_json "$CONFIG_TEMPLATE" "$TMP_JSON" "mcpServers" "$SELECTED_JSON_KEYS"
        TEMPLATE_JSON=$(cat "$TMP_JSON")
        rm -f "$TMP_JSON"
    else
        print_warning "No MCP servers selected, using entire configuration"
        TEMPLATE_JSON=$(cat "$CONFIG_TEMPLATE")
    fi
else
    print_warning "jq not found - using the entire configuration template"
    TEMPLATE_JSON=$(cat "$CONFIG_TEMPLATE")
fi

# Create temporary config with current versions
print_info "Updating configuration with Python $PYTHON_VERSION and Node.js $NODE_VERSION..."

# First replace versions in a temporary file
TMP_CONFIG=$(mktemp)
echo "$TEMPLATE_JSON" | \
    sed -e "s|\$NODE_VERSION|$NODE_VERSION|g" \
        -e "s|\$PYTHON_VERSION|$PYTHON_VERSION|g" > "$TMP_CONFIG"

# Then replace environment variables
sed -e "s|\$HOME|$HOME|g" \
    -e "s|\$GITHUB_TOKEN|$GITHUB_TOKEN|g" \
    "$TMP_CONFIG" > "$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

# Clean up
rm -f "$TMP_CONFIG"

# Install markitdown-mcp if needed
if command_exists "uv" && ! uv tool list | grep -q "markitdown-mcp"; then
    if confirm "Would you like to install markitdown-mcp?"; then
        uv tool install markitdown-mcp
    else
        print_warning "Skipping markitdown-mcp installation"
    fi
fi

# Install @anthropic-ai/claude-code if needed
if confirm "Would you like to install @anthropic-ai/claude-code?"; then
    print_info "Installing @anthropic-ai/claude-code..."
    npm install -g @anthropic-ai/claude-code@latest
    print_success "@anthropic-ai/claude-code installed"
    # Add MCP server globally from Claude Desktop
    claude mcp add-from-claude-desktop -s user

    # Deploy Claude Code settings
    CLAUDE_CODE_SETTINGS_DIR="$HOME/.claude"
    CLAUDE_CODE_SETTINGS_SOURCE="$SCRIPT_DIR/settings.json"
    CLAUDE_CODE_SETTINGS_TARGET="$CLAUDE_CODE_SETTINGS_DIR/settings.json"

    if [ -f "$CLAUDE_CODE_SETTINGS_SOURCE" ]; then
        mkdir -p "$CLAUDE_CODE_SETTINGS_DIR"

        if [ -f "$CLAUDE_CODE_SETTINGS_TARGET" ]; then
            local_backup="$CLAUDE_CODE_SETTINGS_TARGET.$(date +%Y%m%d%H%M%S).bak"
            cp "$CLAUDE_CODE_SETTINGS_TARGET" "$local_backup"
            print_info "Existing Claude Code settings backed up to $local_backup"
        fi

        cp "$CLAUDE_CODE_SETTINGS_SOURCE" "$CLAUDE_CODE_SETTINGS_TARGET"
        print_success "Claude Code settings applied to $CLAUDE_CODE_SETTINGS_TARGET"
    else
        print_warning "Claude Code settings template not found at $CLAUDE_CODE_SETTINGS_SOURCE"
    fi

    # Deploy Claude Code resources (agents, commands, tools, hooks, project-template)
    print_info "Deploying Claude Code configurations..."

    # Ask if user wants to clean up old files
    CLEANUP_MODE=false
    if confirm "Would you like to clean up old files before deploying? (removes all existing files in each resource directory)"; then
        CLEANUP_MODE=true
        print_warning "Cleanup mode enabled - old files will be removed"
    fi

    for resource_type in agents commands tools hooks project-template skills; do
        resource_dir="$SCRIPT_DIR/$resource_type"

        if [ -d "$resource_dir" ]; then
            print_info "Deploying $resource_type..."

            # Clean up if requested
            if [ "$CLEANUP_MODE" = true ] && [ -d "$CLAUDE_CODE_SETTINGS_DIR/$resource_type" ]; then
                print_warning "Removing old $resource_type..."
                rm -rf "$CLAUDE_CODE_SETTINGS_DIR/$resource_type"
            fi

            mkdir -p "$CLAUDE_CODE_SETTINGS_DIR/$resource_type"
            cp -r "$resource_dir"/* "$CLAUDE_CODE_SETTINGS_DIR/$resource_type/" 2>/dev/null || true

            # Set executable permissions for scripts
            if [ "$resource_type" = "tools" ] || [ "$resource_type" = "hooks" ] || [ "$resource_type" = "skills" ]; then
                # Use find to handle nested directory structures (skills may have subdirectories with scripts)
                find "$CLAUDE_CODE_SETTINGS_DIR/$resource_type" -type f \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} \; 2>/dev/null || true
            fi

            print_success "$resource_type deployed"
        fi
    done

    # Setup notification permissions for hooks
    if [ -d "$SCRIPT_DIR/hooks" ]; then

        # Setup notification permissions via Script Editor
        echo ""
        print_info "Setting up notification permissions..."
        echo ""
        print_info "To enable notifications, you need to grant permission to Script Editor."
        echo "A test notification script will be opened in Script Editor."
        echo ""

        # Create a temporary AppleScript file for notification permission request
        TEMP_SCRIPT=$(mktemp).scpt
        cat > "$TEMP_SCRIPT" << 'EOF'
display notification "Test notification from Claude Code" with title "Notification Permission Request"
EOF

        # Open the script in Script Editor
        open -a "Script Editor" "$TEMP_SCRIPT"
        sleep 1

        echo "Please follow these steps in Script Editor:"
        echo "  1. Click the 'Run' button (▶) at the top of the window"
        echo "  2. Grant notification permission when prompted"
        echo "  3. You should see a notification appear"
        echo ""

        if confirm "Have you run the script and granted permission?"; then
            # Clean up temporary script
            rm -f "$TEMP_SCRIPT"
            print_success "Notification permissions setup complete"
            print_info "Note: You can close Script Editor now"
        else
            # Clean up even if user skips
            rm -f "$TEMP_SCRIPT"
            print_info "You can grant notification permissions later by running the script manually"
        fi
    fi
fi

print_success "Claude Desktop configuration updated successfully"
