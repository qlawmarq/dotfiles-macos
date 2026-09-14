# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular macOS dotfiles management system that automates development environment setup. Each directory under `modules/` is an independent module, installed in dependency order resolved from `modules/dependencies.txt` (e.g., `claude: brew mise` means claude depends on brew and mise).

## Development Guidelines

### When modifying modules:

1. Each module has `apply.sh` (apply settings) and optionally `backup.sh` (backup settings)
2. Every module must have an entry in `modules/dependencies.txt`, even with no dependencies (`mynewmodule:`)
3. Use the shared utilities in `lib/` for consistency

### Shell scripts conventions:

- Use `#!/bin/bash` (required for arrays, `[[ ]]`, `read -p` used in this project)
- Source common utilities: `. "$DOTFILES_DIR/lib/utils.sh"`
- Handle errors gracefully with user prompts to continue/abort
- Use colored output functions: `print_success()`, `print_error()`, `print_info()`, `print_warning()`
- Note: macOS ships bash 3.2 (GPL v2); all features used are compatible

## Claude Code Integration

The `claude` module's design notes (symlinked skills, settings.json merge semantics, notifications, MCP) live in `modules/claude/CLAUDE.md`.

Never edit `~/.claude.json` directly to configure MCP — it is live client state the CLI writes continuously; use `claude mcp add-json`.

## Testing Changes

For the keyboard module: test that system shortcuts (including Input Source switching) are preserved.
