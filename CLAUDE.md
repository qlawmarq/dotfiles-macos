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
sh apply.sh

# Backup existing configurations
sh backup.sh

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
- `keyboard-shortcuts.xml`: System keyboard shortcuts in Apple's native XML format (complete export)
- `keyboard-settings.txt`: Application keyboard shortcuts in human-readable format
- Shell configs are symlinked from `dotfiles/` to home directory

## Claude Code Integration

This repository provides user-level Claude Code configurations that are shared across all projects.

### Available Resources

**Agents** (`~/.claude/agents/`) - 日本語版:
- **bug-hunter_JA**: 体系的なデバッグとバグ調査
- **test-coverage_JA**: テストカバレッジ分析とテストケース提案
- **security-guardian_JA**: セキュリティレビューと脆弱性評価

**Commands** (`~/.claude/commands/`) - 日本語版:
- **/transcripts_JA**: コンパクト後の会話履歴を復元
- **/commit_JA**: Gitコミット作成支援

**Tools** (`~/.claude/tools/`):
- **hook_precompact.py**: トランスクリプトエクスポート（PreCompactフック）
- **hook_logger.py**: フック用ログユーティリティ
- **statusline-example.sh**: ステータスラインカスタマイズサンプル

**Hooks** (`~/.claude/hooks/`):
- **notify.sh**: 通知フック（タスク完了時の macOS 通知）

These resources are automatically deployed to `~/.claude/` when running `sh apply.sh` (claude module).

## Testing Changes

When modifying setup scripts:

1. Test module application: `sh modules/<module_name>/apply.sh`
2. Test full application flow: `sh apply.sh` (select specific modules)
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
