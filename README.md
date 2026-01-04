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

## Usage

### Initial Setup

When setting up a new Mac for the first time:

https://github.com/qlawmarq/dotfiles-macos/archive/refs/heads/main.zip


```sh
cd ~/Downloads/dotfiles-macos-main
bash apply.sh
# Install at least the 'brew' and 'mise' modules first to ensure dependencies are met.
```

Or clone the repository with submodules (Need `git` installed):

```sh
# Clone with submodules (includes shared configurations)
git clone --recurse-submodules https://github.com/qlawmarq/dotfiles-macos.git
cd dotfiles-macos
bash apply.sh
```

If you cloned without `--recurse-submodules`, initialize the submodule:

```sh
git submodule update --init --recursive
```

### Apply Settings

When applying configurations to an existing setup:

```sh
bash apply.sh
```

- You will be prompted to select which modules to apply.
- The script will resolve dependencies and determine the correct application order.
- Each selected module will run its own apply script in the proper sequence.

### Backup Configurations

To backup current system settings to configuration files:

```sh
bash backup.sh
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

