# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular macOS dotfiles management system that automates development environment setup. It uses a sophisticated dependency resolution system to install and configure development tools in the correct order.

## Architecture

The repository uses a modular architecture with 8 independent modules:

- **brew**: Homebrew package management (`.Brewfile`)
- **mise**: Runtime version management
- **claude**: Claude Code setup — CLI, settings, hooks, skills and MCP servers
- **dotfiles**: Shell configurations (`.zprofile`, `.zshrc`)
- **git**: Git configuration with SSH key setup
- **vscode**: VS Code settings and extensions
- **finder**: macOS Finder preferences and settings
- **keyboard**: Keyboard shortcuts and modifier key mappings

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
- `modules/claude/mcp-servers.json`: MCP server template for Claude Code (user scope)
- `.gitconfig`: Git aliases and configurations
- `vscode/settings.json`: VS Code preferences
- `finder-settings.txt`: macOS Finder preferences in human-readable format
- `keyboard-shortcuts.xml`: System keyboard shortcuts in Apple's native XML format (complete export)
- `modifier-keys.txt`: Modifier key mappings (Cmd/Ctrl swap etc.) in human-readable format
- `keyboard-settings.txt`: Application keyboard shortcuts in human-readable format
- Shell configs are symlinked from `dotfiles/` to home directory

## Claude Code Integration

This repository provides user-level Claude Code configuration shared across all projects.
The `claude` module targets **Claude Code only** — Claude Desktop is no longer configured here.

### Step-based application

`modules/claude/apply.sh` is a dispatcher. Every step is independent, so skills can be
updated without reinstalling the CLI:

```bash
sh modules/claude/apply.sh            # interactive step menu (all steps when non-TTY)
sh modules/claude/apply.sh skills     # one step
sh modules/claude/apply.sh skills mcp # several (always run in canonical order)
sh modules/claude/apply.sh all
CLAUDE_APPLY_STEPS=skills sh modules/claude/apply.sh
```

| Step | Effect |
| --- | --- |
| `cli` | `npm install -g @anthropic-ai/claude-code@latest` |
| `settings` | Merges `modules/common/claude/settings.json` into `~/.claude/settings.json` |
| `hooks` | Deploys macOS notification hooks to `~/.claude/hooks/` |
| `skills` | Symlinks skills into `~/.claude/skills/` and `~/.agents/skills/` |
| `mcp` | Applies `modules/claude/mcp-servers.json` to the Claude Code user scope |
| `notifications` | One-time macOS notification permission grant |
| `doctor` | Read-only drift report (broken links, submodule edits, MCP drift) |

`modules/claude/backup.sh` mirrors this with `mcp` and `settings` steps.

A step whose prerequisites are missing (no `jq`, no `claude`, no resolvable `npx`)
logs a warning and skips, rather than failing the module.

### Skills are symlinked

`~/.claude/skills/<name>` are symlinks into `modules/common`, which Claude Code follows.
Consequences:

- Submodule updates take effect immediately; no re-run needed to pick up edits.
- **Claude Code edits skills in place inside the submodule.** This is detectable and
  reversible: `sh modules/claude/apply.sh doctor` reports it, `git -C modules/common
  checkout -- skills claude/skills` discards it, `git -C modules/common commit` keeps it.
  Under the previous copy-based deployment the same edit was invisible to git and was
  silently destroyed by the next apply.
- Stale skills are pruned by deleting the link. Pruning only touches symlinks whose
  target is inside `modules/common`, so hand-written skills in `~/.claude/skills/` survive.
- On first run, pre-existing real directories are moved to
  `~/.claude/skills.pre-symlink.<timestamp>/` rather than deleted.
- A moved or renamed repository leaves dangling links: the skills disappear from `/skills`,
  `doctor` lists them, and re-running the `skills` step repairs them.
- `~/.agents/skills/` (Codex CLI / Gemini CLI) defaults to copy mode because their
  symlink support is unverified. Set `AGENTS_SKILLS_MODE=symlink` to opt in.

### settings.json merge semantics

`~/.claude/settings.json` is merged, not overwritten, so UI-written keys survive:

- `permissions` and `hooks` are **repository-owned** and replaced wholesale, so a key
  removed from the repository is also removed from the live file.
- Every other key is deep-merged, preserving local values such as `modelSettings`.
- The previous file is snapshotted to `~/.claude/.dotfiles-backups/` first.
- `backup.sh settings` writes back an allowlist (`$schema`, `permissions`, `model`,
  `tui`, `hooks`, `statusLine`, `env`) so machine-local UI state never enters the
  submodule.

`tui` is pinned to `fullscreen`. The default `classic` renderer draws inline into the
terminal scrollback without the alternate screen, so once a frame grows taller than the
pane, or the pane width changes and the terminal reflows, it can no longer erase what has
scrolled off and re-emits it: duplicated bands of lines and tables rendered half at the
old width and half at the new one. Measured here under tmux at 120x20 with a width
change: `classic` left 7 distinct lines repeated up to 14 times in the scrollback,
`fullscreen` left none (`#{alternate_on}` 0 vs 1). The cost is that Claude Code owns the
screen, so tmux copy-mode no longer scrolls its output — the `alternate_on` branch of the
WheelUp binding in `tmux/.tmux.conf` forwards the wheel to Claude Code instead. Revert
per machine with `/tui default`.

Bash permission patterns use a `:*` suffix for prefix matching: `Bash(git status:*)`
matches `git status --short`. `Bash(pnpm *)` is invalid and does nothing.

**Customization:** user-level overrides go in `~/.claude/settings.json`; per-project
rules in `.claude/settings.local.json`.

### MCP servers

MCP is configured for the Claude Code **user scope** via `claude mcp add-json`, not by
editing `~/.claude.json` directly (that file is live client state the CLI writes
continuously).

`modules/claude/mcp-servers.json` uses `{{NPX}}`, `{{NODE_BIN}}` and `{{HOME}}`
placeholders, resolved at apply time by `resolve_npx` (`mise which npx`, falling back to
`command -v npx`). This keeps the template free of node versions and lets the Linux and
Windows dotfiles repositories share the same file by swapping the resolver.

`backup.sh mcp` reverses the substitution, normalizing version-pinned mise paths back to
placeholders. Servers present in the user scope but absent from the template are reported,
never deleted automatically — promote them with `bash modules/claude/backup.sh mcp`.

## Testing Changes

When modifying setup scripts:

1. Test module application: `bash modules/<module_name>/apply.sh`
2. Test full application flow: `bash apply.sh` (select specific modules)
3. Verify dependencies are correctly resolved
4. Check symlinks are created properly (`ls -la ~/.claude/skills`)
5. For keyboard module: Test that system shortcuts (including Input Source switching) are preserved

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