# macOS Setup Scripts

A modular, interactive setup and configuration tool for quickly provisioning and synchronizing your macOS development environment using dotfiles and custom scripts. The system intelligently manages dependencies between modules to ensure proper installation order.

---

## Table of Contents

- [Overview](#overview)
- [Available Modules](#available-modules)
- [Module Dependencies](#module-dependencies)
- [Requirements](#requirements)
- [Usage](#usage)
- [Module Structure](#module-structure)
- [Customization](#customization)
- [Dependency Management](#dependency-management)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Overview

This repository provides a set of scripts to automate the initial setup and ongoing synchronization of your macOS environment. It is designed to be modular, allowing you to select which components (modules) to install or sync, making it easy to maintain and customize your dotfiles and related configurations.

The system intelligently manages dependencies between modules, ensuring they are installed in the correct order.

---

## Available Modules

### Shared Configurations (via common submodule)

Common configurations are managed in [dotfiles-common](https://github.com/qlawmarq/dotfiles-common) and shared with [dotfiles-linux](https://github.com/qlawmarq/dotfiles-linux):

- **common/tmux**: Cross-platform tmux configuration with automatic clipboard detection
- **common/claude**: Claude Code settings (agents, commands, skills, tools, hooks) for consistent development experience across platforms

### Platform-Specific Modules

The following macOS-specific modules are available:

- **brew**: Installs and configures Homebrew and selected packages
- **mise**: Sets up runtime environment manager for Node.js, Python, and other tools
- **tmux**: tmux setup (uses common/tmux configuration)
- **dotfiles**: Configures shell profiles (.zshrc, .zprofile, .zshenv)
- **git**: Sets up Git configuration, aliases, and global settings
- **vscode**: Installs and configures Visual Studio Code and extensions
- **finder**: Manages macOS Finder preferences and settings
- **keyboard**: Manages keyboard shortcuts and Karabiner-Elements configuration
- **claude**: Configures Claude Desktop (MCP servers) and Claude Code CLI (uses common/claude)

Each module is independent but may depend on other modules for proper functionality.

---

## Module Dependencies

Modules can have dependencies on other modules. For example, the `claude` module requires both `brew` and `mise` to be installed first. The dependency relationships are defined in `modules/dependencies.txt` and are automatically resolved during installation.

The installation script automatically detects these dependencies and ensures modules are installed in the correct order.

---

## Requirements

Before running these scripts, ensure you have the following:

- **macOS** (tested on the latest version Sequoia)
- **bash/zsh/sh** (available by default on macOS)
- **git** (for cloning this repository, if not already downloaded)

The scripts will check for and attempt to install other necessary dependencies as needed.

---

## Claude Code Configuration

This repository provides a comprehensive Claude Code setup with:

- **Configurations** (`~/.claude/`): Shared agents, commands, tools, and hooks available across all projects
- **Permission Automation**: Hybrid approach using Permission Modes + PreToolUse Hooks to reduce permission prompts
  - File edits auto-approved during session (`defaultMode: "acceptEdits"`)
  - Safe read-only commands auto-approved (cat, ls, grep, git status, etc.)
  - Build/test/lint commands auto-approved (pnpm test, npm run build, etc.)
  - Dangerous commands blocked or require confirmation (sudo, rm -rf, git push, etc.)

### Permission Automation Details

The claude module configures automatic permission handling through two mechanisms:

1. **Permission Mode** (`defaultMode: "acceptEdits"`):

   - File Edit/Write operations are automatically approved for the session
   - Reduces interruptions when Claude modifies code

2. **PreToolUse Hook** (`hooks/auto-approve-safe-commands.sh`):
   - Automatically approves safe bash commands without prompting
   - Uses whitelist approach - only known-safe commands are auto-approved
   - Handles complex commands with shell operators (&&, ||, ;, |)
   - Categories of auto-approved commands:
     - Read-only: `cat`, `ls`, `grep`, `find`, `head`, `tail`, etc.
     - Git read: `git status`, `git diff`, `git log`, `git show`, etc.
     - Testing: `pnpm test`, `npm test`, `pytest`, `jest`, etc.
     - Linting: `eslint`, `prettier`, `ruff check`, `black`, etc.
     - Building: `pnpm build`, `npm run dev`, `cargo build`, etc.
   - Unknown commands prompt for user approval (fail-safe approach)

You can customize the auto-approved patterns by editing `~/.claude/hooks/auto-approve-safe-commands.sh`.

---

## Usage

### Initial Setup

When setting up a new Mac for the first time:

```sh
# Clone with submodules (includes shared configurations)
git clone --recurse-submodules https://github.com/qlawmarq/dotfiles-macos.git
cd dotfiles-macos
sh apply.sh
```

If you cloned without `--recurse-submodules`, initialize the submodule:

```sh
git submodule update --init --recursive
```

### Apply Settings

When applying configurations to an existing setup:

```sh
sh apply.sh
```

- You will be prompted to select which modules to apply.
- The script will resolve dependencies and determine the correct application order.
- Each selected module will run its own apply script in the proper sequence.

### Backup Configurations

To backup current system settings to configuration files:

```sh
sh backup.sh
```

- Select which modules to backup.
- Each selected module will run its sync script.

---

## Module Structure

Modules are located in the `modules/` directory. Each module is a subdirectory that can contain:

- `apply.sh` — Script for applying settings to the system.
- `backup.sh` — Script for backing up current settings to configuration files.
- Additional files or resources as needed.

Example structure:

```
modules/
  ├── common/              # Submodule (dotfiles-common)
  │   ├── claude/         # Shared Claude Code configurations
  │   └── tmux/           # Shared tmux configuration
  ├── dependencies.txt     # Defines module dependencies
  ├── brew/
  │   ├── .Brewfile       # List of packages to install
  │   ├── apply.sh         # Apply settings script
  │   └── backup.sh         # Backup settings script
  ├── tmux/
  │   ├── apply.sh         # Wrapper script (uses common/tmux)
  │   └── backup.sh         # Backup script
  ├── claude/
  │   ├── claude_desktop_config.json  # Desktop-specific configuration
  │   ├── apply.sh                     # Apply script (uses common/claude)
  │   └── backup.sh                     # Backup script
  ├── finder/
  │   ├── finder-settings.txt         # Finder preferences configuration
  │   ├── apply.sh                     # Apply settings script
  │   └── backup.sh                     # Backup settings script
  ├── keyboard/
  │   ├── karabiner.json              # Karabiner-Elements configuration
  │   ├── complex_modifications/      # Karabiner complex modifications
  │   ├── keyboard-shortcuts.xml      # System keyboard shortcuts (XML export)
  │   ├── keyboard-settings.txt       # Application keyboard shortcuts
  │   ├── apply.sh                     # Apply settings script
  │   └── backup.sh                     # Backup settings script
  ├── ...
```

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

---

## Troubleshooting

### Common Issues

- **Module fails to apply**: Check if all its dependencies were successfully applied. Try running the module's apply script directly to see detailed error messages.

- **Dependency resolution error**: Ensure there are no circular dependencies in your `dependencies.txt` file.

- **Permission issues**: Make sure all script files have execution permissions:
  ```sh
  chmod +x apply.sh backup.sh lib/*.sh modules/*/apply.sh modules/*/backup.sh
  ```

### Debug MCP server for Claude Desktop

```sh
tail -n 20 -f ~/Library/Logs/Claude/mcp*.log
```

### Check the current config for Claude Desktop

```sh
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

---

## License

MIT
