# Repository Guidelines

## Project Structure & Module Organization
- Root scripts: `apply.sh` (install/ configure) and `backup.sh` (export current settings).
- Shared helpers: `lib/` (`utils.sh`, `menu.sh`, `dependencies.sh`).
- Modules: `modules/<name>/` with `apply.sh` and optional `backup.sh`. Dependencies live in `modules/dependencies.txt` (e.g., `claude: brew mise`).
- Notable modules: `brew`, `mise`, `claude`, `codex`, `dotfiles`, `git`, `vscode`, `finder`, `keyboard`.

## Build, Test, and Development Commands
- Apply selected modules interactively: `sh apply.sh`.
- Backup selected modules: `bash backup.sh`.
- Run a single module: `bash modules/<module>/apply.sh` or `bash modules/<module>/backup.sh`.
- Ensure executability if needed: `chmod +x apply.sh backup.sh lib/*.sh modules/*/*.sh`.

## Coding Style & Naming Conventions
- Language: Bash. Prefer `#!/bin/bash`, lowercase module dirs, `apply.sh`/`backup.sh` names.
- Indentation: 4 spaces; avoid tabs.
- Utilities: reuse `print_info/success/warning/error`, `confirm`, and `check_macos` from `lib/utils.sh`.
- Paths: derive with `SCRIPT_DIR` and `DOTFILES_DIR`; avoid hard-coded absolute paths.
- Dependencies: declare in `modules/dependencies.txt` whenever a module relies on another.

## Testing Guidelines
- Syntax check: `bash -n modules/<module>/apply.sh` (and `backup.sh`).
- Lint (optional): `shellcheck modules/<module>/*.sh` if available via Homebrew.
- Manual verification: run the module script, then confirm expected files (e.g., `~/.zshrc`, `~/.codex/config.toml`) and app settings. Use module-level scripts for quicker iteration.

## Commit & Pull Request Guidelines
- Commit style: Conventional Commits used in this repo (e.g., `feat:`, `fix:`, `chore:`, `refactor:`; optional scope and PR number).
- PRs must include:
  - What/Why summary and affected modules.
  - Test plan with exact commands (e.g., `bash modules/git/apply.sh`).
  - Updates to `modules/dependencies.txt` and documentation when relevant.
  - Screenshots/log snippets when UI/config changes are involved (e.g., Finder, Keyboard).

## Security & Configuration Tips
- Never commit secrets. Sensitive env vars are stored in `~/.env_secrets` and are git-ignored here.
- Prefer templates with placeholders (e.g., `modules/codex/config.toml`) and prompt users for values.
- These scripts target macOS; validate on macOS and handle missing apps gracefully with `confirm`.

