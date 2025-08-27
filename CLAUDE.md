# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular macOS dotfiles management system that automates development environment setup. It uses a sophisticated dependency resolution system to install and configure development tools in the correct order.

## Architecture

The repository uses a modular architecture with 8 independent modules:
- **brew**: Homebrew package management (`.Brewfile`)
- **mise**: Runtime version management
- **claude**: Claude Desktop configuration with MCP servers
- **dotfiles**: Shell configurations (`.zprofile`, `.zshrc`)
- **git**: Git configuration with SSH key setup
- **vscode**: VS Code settings and extensions
- **finder**: macOS Finder preferences and settings
- **keyboard**: Keyboard shortcuts and Karabiner-Elements configuration

Module dependencies are defined in `modules/dependencies.txt` (e.g., `claude: brew mise` means claude depends on brew and mise).

## Key Commands

```bash
# Initial setup - interactive module selection with dependency resolution
sh init.sh

# Sync existing configurations
sh sync.sh

# Debug Claude MCP servers
tail -n 20 -f ~/Library/Logs/Claude/mcp*.log
```

## Development Guidelines

### When modifying modules:
1. Each module has `init.sh` (setup) and optionally `sync.sh` (update)
2. Dependencies must be declared in `modules/dependencies.txt`
3. Use the shared utilities in `lib/` for consistency:
   - `lib/utils.sh`: General utilities and macOS checks  
   - `lib/defaults.sh`: macOS defaults command utilities for settings management
   - `lib/menu.sh`: Interactive selection menus
   - `lib/dependencies.sh`: Dependency resolution logic

### Shell scripts conventions:
- Use `#!/bin/sh` for portability (not bash-specific features)
- Source common utilities: `. "$(dirname "$0")/../../lib/common.sh"`
- Handle errors gracefully with user prompts to continue/abort
- Use colored output functions: `success()`, `error()`, `info()`

### Configuration files:
- `.Brewfile`: Homebrew packages and casks
- `claude_desktop_config.json`: MCP server configurations
- `.gitconfig`: Git aliases and configurations
- `vscode/settings.json`: VS Code preferences
- `finder-settings.txt`: macOS Finder preferences in human-readable format
- `karabiner.json`: Karabiner-Elements configuration for key mappings
- `keyboard-settings.txt`: macOS keyboard shortcuts in human-readable format
- Shell configs are symlinked from `dotfiles/` to home directory

## Testing Changes

When modifying setup scripts:
1. Test module initialization: `sh modules/<module_name>/init.sh`
2. Test full setup flow: `sh init.sh` (select specific modules)
3. Verify dependencies are correctly resolved
4. Check symlinks are created properly

## Claude Desktop MCP Servers

This repository configures extensive MCP servers for Claude Desktop:
- filesystem operations
- GitHub integration
- web fetching
- shell automation
- Various development tools

Configuration is in `modules/claude/claude_desktop_config.json` and deployed to `~/Library/Application Support/Claude/claude_desktop_config.json`.