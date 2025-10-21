---
description: Generate language-specific PRP commands for this project
category: prp
argument-hint: [--type typescript|python|go|rust|auto]
allowed-tools: Read, Write, Glob, Bash
---

# Setup Language-Specific PRP Commands

Updates PRP commands and templates to be specific to the language or framework of the current project.

An overview of the PRP framework can be found in `~/.claude/project-template/PRPs/README_JA.md`.

If the PRP framework is not in use, this command will prompt the user to run `~/.claude/commands/prp/prp-init.md` and abort the operation.

## Usage

To auto-detect the project type:

```
/prp-lang-setup
```

Or, to specify the project type:

```
/prp-lang-setup --type typescript
/prp-lang-setup --type python
/prp-lang-setup --type go
/prp-lang-setup --type rust
```

## What This Command Does

0. **Understand the Project Overview**:

- `README.md`
- `CLAUDE.md`
- `AGENTS.md`

1. **Detect Project Type**:

- `package.json` → TypeScript/JavaScript/Node.js
- `pyproject.toml` or `setup.py` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `Gemfile` → Ruby
- `pom.xml` or `build.gradle` → Java

2. **Identify Available Tools in the Project**:

- Linters: ESLint, Ruff, golangci-lint, Clippy
- Formatters: Prettier, Black, gofmt, rustfmt
- Test Runners: Jest, pytest, Go test, Cargo test
- Build Tools: tsc, webpack, setuptools, cargo

3. **Check for Existing PRP Framework Commands and Templates**:

- Checks the usage of the existing PRP framework (commands and templates) that may need updating.
- Checks if the `PRPs/` folder exists.
  - If it exists, checks the content of the templates.
- Checks if PRP-related commands exist in `.claude/commands/`.
  - If they exist, checks the content of the commands.
- If neither exists, it prompts the user to run the `/prp-init` command and aborts the operation (assumes that `~/.claude/commands/prp/prp-init.md` has been run beforehand).

4. **Generate Language-Specific Commands and Templates** (in `PRPs/templates/`):

- If existing PRP framework commands and templates are found, it updates the existing templates:
  - Language-specific PRP templates that include:
    - Language-specific validation commands
    - Framework-specific patterns
    - Common pitfalls and notes for the language/framework

## Implementation Process

0. Understand the project and the PRP framework overview.
1. Detect the project type or use the specified type.
2. Scan for available tools (linters, formatters, test runners).
3. Check the usage of the existing PRP framework.
4. Generate language-specific commands and templates (updating the existing PRP framework), including:
   - Tool-specific validation commands
   - Language-specific patterns and conventions
   - Common pitfalls of the ecosystem
5. Display a summary of the created files and the next steps.

## Language-Specific Features

### TypeScript/JavaScript

- TypeScript compiler integration
- ESLint and Prettier configuration
- Jest/Vitest test patterns
- Next.js/React/Vue framework detection
- Package manager detection (npm/pnpm/yarn/bun)

### Python

- Ruff linting and formatting
- Mypy type checking
- pytest test patterns
- Virtual environment handling
- Poetry/uv/pip detection

### Go

- gofmt formatting
- golangci-lint integration
- Go test patterns
- Module structure

### Rust

- rustfmt formatting
- Clippy linting
- Cargo test patterns
- Workspace detection

## Important Notes

- Commands are **project-specific** (saved in `.claude/commands/`)
- Templates are **project-specific** (saved in `PRPs/templates/`)
- These commands use the same underlying PRP framework but with language-specific default settings.

## Additional Guidance

$ARGUMENTS
