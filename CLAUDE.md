# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular macOS dotfiles management system that automates development environment setup. It uses a sophisticated dependency resolution system to install and configure development tools in the correct order.

## Architecture

The repository uses a modular architecture with 8 independent modules:

- **brew**: Homebrew package management (`.Brewfile`)
- **mise**: Runtime version management
- **claude**: Claude Desktop configuration with MCP servers and Claude Code setup
- **dotfiles**: Shell configurations (`.zprofile`, `.zshrc`)
- **git**: Git configuration with SSH key setup
- **vscode**: VS Code settings and extensions
- **finder**: macOS Finder preferences and settings
- **keyboard**: Keyboard shortcuts and Karabiner-Elements configuration

Module dependencies are defined in `modules/dependencies.txt` (e.g., `claude: brew mise` means claude depends on brew and mise).

## Key Commands

```bash
# Initial setup - interactive module selection with dependency resolution
bash apply.sh

# Backup existing configurations
bash backup.sh

# Debug Claude MCP servers
tail -n 20 -f ~/Library/Logs/Claude/mcp*.log
```

## Development Guidelines

### When modifying modules:

1. Each module has `apply.sh` (apply settings) and optionally `backup.sh` (backup settings)
2. Dependencies must be declared in `modules/dependencies.txt`
3. Use the shared utilities in `lib/` for consistency:
   - `lib/utils.sh`: General utilities and macOS checks
   - `lib/defaults.sh`: macOS defaults command utilities for settings management (includes hybrid XML/text approach)
   - `lib/menu.sh`: Interactive selection menus
   - `lib/dependencies.sh`: Dependency resolution logic

### Shell scripts conventions:

- Use `#!/bin/bash` (required for arrays, `[[ ]]`, `read -p` used in this project)
- Source common utilities: `. "$DOTFILES_DIR/lib/utils.sh"`
- Handle errors gracefully with user prompts to continue/abort
- Use colored output functions: `print_success()`, `print_error()`, `print_info()`, `print_warning()`
- Note: macOS ships bash 3.2 (GPL v2); all features used are compatible

### Configuration files:

- `.Brewfile`: Homebrew packages and casks
- `claude_desktop_config.json`: MCP server configurations
- `.gitconfig`: Git aliases and configurations
- `vscode/settings.json`: VS Code preferences
- `finder-settings.txt`: macOS Finder preferences in human-readable format
- `karabiner.json`: Karabiner-Elements configuration for key mappings
- `keyboard-shortcuts.xml`: System keyboard shortcuts in Apple's native XML format (complete export)
- `keyboard-settings.txt`: Application keyboard shortcuts in human-readable format
- Shell configs are symlinked from `dotfiles/` to home directory

## Claude Code Integration

This repository provides user-level Claude Code configurations that are shared across all projects.

These resources are automatically deployed to `~/.claude/` when running `bash apply.sh` (claude module).

### Permission Automation System

The claude module implements a hybrid permission automation system to reduce manual approval prompts:

**Components:**

1. `modules/claude/settings.json` - Base configuration with:

   - `permissions.defaultMode: "acceptEdits"` - Auto-approve file edits during session
   - `permissions.allow` - Whitelist for safe MCP tools and specific Bash patterns
   - `permissions.ask` - Confirmation required for risky operations (git push, npm install)
   - `permissions.deny` - Block dangerous operations (sudo, sensitive file reads)

2. `modules/claude/hooks/auto-approve-safe-commands.sh` - PreToolUse hook that:
   - Auto-approves read-only commands (cat, ls, grep, git status, etc.)
   - Auto-approves build/test/lint commands (pnpm test, npm run build, etc.)
   - Handles shell operators (&&, ||, ;, |) - ALL parts must be safe
   - Uses fail-safe whitelist approach - unknown commands require user approval
   - Does NOT block commands (blocking is handled by permissions.deny)

**Important Notes:**

- Bash permission patterns use `:*` suffix for prefix matching (not `*`)
- Example: `Bash(git status:*)` matches "git status", "git status --short", etc.
- Patterns like `Bash(pnpm *)` are INVALID and will not work
- The PreToolUse hook provides more flexible pattern matching using regex

**Customization:**

- User-level: Edit `~/.claude/settings.json` for global overrides
- Project-level: Use `.claude/settings.local.json` for project-specific rules
- Hook script: Modify `~/.claude/hooks/auto-approve-safe-commands.sh` for custom patterns

## Testing Changes

When modifying setup scripts:

1. Test module application: `bash modules/<module_name>/apply.sh`
2. Test full application flow: `bash apply.sh` (select specific modules)
3. Verify dependencies are correctly resolved
4. Check symlinks are created properly
5. For keyboard module: Test that system shortcuts (including Input Source switching) are preserved

## Claude Desktop MCP Servers

This repository configures extensive MCP servers for Claude Desktop:

- filesystem operations
- GitHub integration
- web fetching
- shell automation
- Various development tools

Configuration is in `modules/claude/claude_desktop_config.json` and deployed to `~/Library/Application Support/Claude/claude_desktop_config.json`.

---

## Customization

You can easily add, remove, or modify modules to suit your needs:

1. **Add a new module:**  
   Create a new directory under `modules/` (e.g., `modules/mytool/`). Add `apply.sh` and/or `backup.sh` as needed.

2. **Add module dependencies:**  
   Edit `modules/dependencies.txt` to define dependencies for your new module using the format:

   ```
   module_name: dependency1 dependency2 ...
   ```

3. **Customize existing modules:**  
   Edit the `apply.sh` or `backup.sh` scripts within any module to change its setup or backup behavior.

4. **Change the selection menu:**  
   The menu logic is handled in `lib/menu.sh`. You can modify this script to change how modules are presented or selected.

5. **Shared utilities:**  
   Common functions and helpers are in `lib/utils.sh` and `lib/defaults.sh`. You can add your own utility functions here for use across modules.
   - `lib/utils.sh`: General utilities and macOS checks
   - `lib/defaults.sh`: macOS defaults command utilities for settings management

---

## Dependency Management

### How Dependencies Work

1. **Definition**: Dependencies are defined in `modules/dependencies.txt` using a simple format:

   ```
   module_name: dependency1 dependency2 ...
   ```

2. **Resolution**: When modules are selected for installation, the system:

   - Builds a directed graph of dependencies
   - Performs a topological sort to determine installation order
   - Detects circular dependencies and provides appropriate warnings
   - Shows the resolved installation order before proceeding

3. **Installation**: Modules are installed in the resolved order, ensuring that dependencies are satisfied before a dependent module is installed.

4. **Failure Handling**: If a dependency fails to install, the system warns about potential impact on dependent modules and offers the choice to continue or abort.

### Adding Dependencies to New Modules

When creating a new module, simply add an entry to `modules/dependencies.txt` to define its dependencies:

```
mynewmodule: dependency1 dependency2
```

If your module has no dependencies, still add an entry with an empty dependency list:

```
mynewmodule:
```