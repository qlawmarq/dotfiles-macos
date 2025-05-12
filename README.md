# macOS Setup Scripts

A modular, interactive setup and configuration tool for quickly provisioning and synchronizing your macOS development environment using dotfiles and custom scripts.

---

## Table of Contents

- [Overview](#overview)
- [Script Descriptions](#script-descriptions)
- [Dependencies](#dependencies)
- [Module Structure](#module-structure)
- [Customization](#customization)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)

---

## Overview

This repository provides a set of scripts to automate the initial setup and ongoing synchronization of your macOS environment. It is designed to be modular, allowing you to select which components (modules) to install or sync, making it easy to maintain and customize your dotfiles and related configurations.

---

## Script Descriptions

- **init.sh**  
  The main entry point for initial setup. It interactively lists available modules and lets you choose which ones to install. Each module can contain its own initialization logic.

- **sync.sh**  
  Used to synchronize configuration files for selected modules. This is useful for keeping your dotfiles and settings up-to-date across multiple machines.

---

## Dependencies

Before running these scripts, ensure you have the following:

- **macOS** (tested on recent versions)
- **bash/zsh/sh** (should be available by default)
- **Standard macOS command-line tools** (e.g., `git`, `curl`, etc.)
- **jq** (required for JSON parsing and selection menus; install via Homebrew: `brew install jq`)
- **tput** and **stty** (for interactive terminal menus; should be available by default on macOS)
- **python3** or **python** (used as a fallback for JSON parsing if jq is not available; can be installed via mise: `mise use -g python@latest`)
- **npm** (required for installing some Node.js-based tools in certain modules; can be installed via mise: `mise use -g node@lts`)
- **VSCode CLI (`code`)** (required for installing VSCode extensions in the VSCode module; see [VSCode documentation](https://code.visualstudio.com/docs/editor/command-line))
- (Optional) Any additional dependencies required by individual modules (see each module's README or script for details)

---

## Module Structure

Modules are located in the `modules/` directory. Each module is a subdirectory that can contain:

- `init.sh` — Initialization script for setting up the module.
- `sync.sh` — Script for syncing configuration files for the module.
- Additional files or resources as needed.

Example structure:

```
modules/
  zsh/
    init.sh
    sync.sh
  vim/
    init.sh
    sync.sh
  ...
```

The main scripts (`init.sh` and `sync.sh`) will automatically detect available modules and their scripts.

---

## Customization

You can easily add, remove, or modify modules to suit your needs:

1. **Add a new module:**  
   Create a new directory under `modules/` (e.g., `modules/mytool/`). Add `init.sh` and/or `sync.sh` as needed.

2. **Customize existing modules:**  
   Edit the `init.sh` or `sync.sh` scripts within any module to change its setup or sync behavior.

3. **Change the selection menu:**  
   The menu logic is handled in `lib/menu.sh`. You can modify this script to change how modules are presented or selected.

4. **Shared utilities:**  
   Common functions and helpers are in `lib/utils.sh`. You can add your own utility functions here for use across modules.

---

## Usage

### Initial Setup

When setting up a new Mac:

```sh
sh init.sh
```

- You will be prompted to select which modules to install.
- Each selected module will run its own setup script.

### Sync Configurations

To synchronize configuration files (e.g., after updating dotfiles):

```sh
sh sync.sh
```

- Select which modules to sync.
- Each selected module will run its sync script.

---

## Troubleshooting

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
