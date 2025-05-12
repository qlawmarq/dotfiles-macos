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

check_macos

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
if ! command_exists "uvx"; then
    print_info "uvx could not be found"
    if command_exists "pip" && confirm "Would you like to install uv using pip?"; then
        pip install uv
    elif command_exists "pip3" && confirm "Would you like to install uv using pip3?"; then
        pip3 install uv
    else
        print_error "pip or pip3 is not installed or installation cancelled."
        exit 1
    fi
fi

# Check if node is installed
if ! command_exists "node"; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Install MCP server-filesystem if needed
if ! npm list -g | grep -q "@modelcontextprotocol/server-filesystem"; then
    if confirm "Would you like to install @modelcontextprotocol/server-filesystem?"; then
        npm install @modelcontextprotocol/server-filesystem -g
    else
        print_warning "Skipping @modelcontextprotocol/server-filesystem installation"
    fi
fi

# Install markitdown-mcp if needed
if command_exists "uv" && ! uv tool list | grep -q "markitdown-mcp"; then
    if confirm "Would you like to install markitdown-mcp?"; then
        uv tool install markitdown-mcp
    else
        print_warning "Skipping markitdown-mcp installation"
    fi
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
BRAVE_API_KEY=""

if [ -f "$CONFIG_FILE" ]; then
    # Extract GitHub token if present
    EXTRACTED_GITHUB_TOKEN=$(grep -o '"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    if [ -n "$EXTRACTED_GITHUB_TOKEN" ]; then
        GITHUB_TOKEN="$EXTRACTED_GITHUB_TOKEN"
    fi
    
    # Extract Brave API key if present
    EXTRACTED_BRAVE_API_KEY=$(grep -o '"BRAVE_API_KEY": "[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    if [ -n "$EXTRACTED_BRAVE_API_KEY" ]; then
        BRAVE_API_KEY="$EXTRACTED_BRAVE_API_KEY"
    fi
fi

# Ask for GitHub token if not already set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Please enter your GitHub Personal Access Token: (https://github.com/settings/personal-access-tokens)"
    read -r GITHUB_TOKEN
fi

# Ask for Brave API key if not already set
if [ -z "$BRAVE_API_KEY" ]; then
    echo "Please enter your Brave API Key: (https://api-dashboard.search.brave.com/app/keys)"
    read -r BRAVE_API_KEY
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
    -e "s|\$BRAVE_API_KEY|$BRAVE_API_KEY|g" \
    "$TMP_CONFIG" > "$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

# Clean up
rm -f "$TMP_CONFIG"

print_success "Claude Desktop configuration updated successfully"