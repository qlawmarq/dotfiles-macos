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
- **keyboard**: Manages keyboard shortcuts and modifier key mappings
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

When setting up a new Mac for the first time, download the repository from:

https://github.com/qlawmarq/dotfiles-macos/archive/refs/heads/main.zip

And open the Terminal App, then run:

```sh
cd ~/Downloads/dotfiles-macos-main
bash apply.sh
# Install at least the 'brew' and 'mise' and 'dotfiles' modules first to ensure dependencies are met.
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

## Troubleshooting

### Common Issues

- **Module fails to apply**: Check if all its dependencies were successfully applied. Try running the module's apply script directly to see detailed error messages.

- **Dependency resolution error**: Ensure there are no circular dependencies in your `dependencies.txt` file.

- **Permission issues**: Make sure all script files have execution permissions:
  ```sh
  chmod +x apply.sh backup.sh lib/*.sh modules/*/apply.sh modules/*/backup.sh
  ```

### Submodule is in detached HEAD state

Git submodules are checked out in detached HEAD by default. When you make changes inside `modules/common` and need to commit/push them:

```sh
cd modules/common

# Check current state
git status          # Shows "HEAD detached at ..."

# Option 1: Attach to main before committing
git checkout main
git merge --ff-only HEAD@{1}   # Fast-forward main to include your detached commits

# Option 2: If you already committed in detached HEAD
CURRENT=$(git rev-parse HEAD)
git checkout main
git merge --ff-only "$CURRENT"

# Then push the submodule and update the parent
git push origin main
cd ../..
git add modules/common
git commit -m "chore: update common submodule"
```

If your local `main` has diverged from the detached commits, use `git merge` (without `--ff-only`) or `git rebase` instead.

### Debug MCP server for Claude Desktop

```sh
tail -n 20 -f ~/Library/Logs/Claude/mcp*.log
```

### Check the current config for Claude Desktop

```sh
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

