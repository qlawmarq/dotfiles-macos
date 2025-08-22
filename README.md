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

The following modules are currently available:

- **brew**: Installs and configures Homebrew and selected packages
- **mise**: Sets up runtime environment manager for Node.js, Python, and other tools
- **claude**: Configures Claude Desktop with MCP servers for AI assistant integration
- **dotfiles**: Configures shell profiles, aliases, and environment variables
- **git**: Sets up Git configuration, aliases, and global settings
- **vscode**: Installs and configures Visual Studio Code and extensions

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

When setting up a new Mac:

```sh
sh init.sh
```

- You will be prompted to select which modules to install.
- The script will resolve dependencies and determine the correct installation order.
- Each selected module will run its own setup script in the proper sequence.

### Sync Configurations

To synchronize configuration files (e.g., after updating dotfiles):

```sh
sh sync.sh
```

- Select which modules to sync.
- Each selected module will run its sync script.

---

## Module Structure

Modules are located in the `modules/` directory. Each module is a subdirectory that can contain:

- `init.sh` — Initialization script for setting up the module.
- `sync.sh` — Script for syncing configuration files for the module.
- Additional files or resources as needed.

Example structure:

```
modules/
  ├── dependencies.txt     # Defines module dependencies
  ├── brew/
  │   ├── .Brewfile       # List of packages to install
  │   ├── init.sh         # Installation script
  │   └── sync.sh         # Synchronization script
  ├── claude/
  │   ├── claude_desktop_config.json  # Configuration template
  │   ├── init.sh                     # Installation script
  │   └── sync.sh                     # Synchronization script
  ├── ...
```

---

## Customization

You can easily add, remove, or modify modules to suit your needs:

1. **Add a new module:**  
   Create a new directory under `modules/` (e.g., `modules/mytool/`). Add `init.sh` and/or `sync.sh` as needed.

2. **Add module dependencies:**  
   Edit `modules/dependencies.txt` to define dependencies for your new module using the format:

   ```
   module_name: dependency1 dependency2 ...
   ```

3. **Customize existing modules:**  
   Edit the `init.sh` or `sync.sh` scripts within any module to change its setup or sync behavior.

4. **Change the selection menu:**  
   The menu logic is handled in `lib/menu.sh`. You can modify this script to change how modules are presented or selected.

5. **Shared utilities:**  
   Common functions and helpers are in `lib/utils.sh`. You can add your own utility functions here for use across modules.

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

- **Module fails to install**: Check if all its dependencies were successfully installed. Try running the module's init script directly to see detailed error messages.

- **Dependency resolution error**: Ensure there are no circular dependencies in your `dependencies.txt` file.

- **Permission issues**: Make sure all script files have execution permissions:
  ```sh
  chmod +x init.sh sync.sh lib/*.sh modules/*/init.sh modules/*/sync.sh
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
