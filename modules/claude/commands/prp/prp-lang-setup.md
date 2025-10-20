---
description: Generate language-specific PRP commands for this project
argument-hint: [--type typescript|python|go|rust|auto]
allowed-tools: Read, Write, Glob, Bash
---

# Setup Language-Specific PRP Commands

Generate language or framework-specific PRP commands and templates for the current project.

## Usage

Auto-detect project type:
```
/prp-lang-setup
```

Or specify the project type:
```
/prp-lang-setup --type typescript
/prp-lang-setup --type python
/prp-lang-setup --type go
/prp-lang-setup --type rust
```

## What This Command Does

1. **Detects Project Type** by checking for:
   - `package.json` → TypeScript/JavaScript/Node.js
   - `pyproject.toml` or `setup.py` → Python
   - `go.mod` → Go
   - `Cargo.toml` → Rust
   - `Gemfile` → Ruby
   - `pom.xml` or `build.gradle` → Java

2. **Identifies Available Tools** in the project:
   - Linters: ESLint, Ruff, golangci-lint, Clippy
   - Formatters: Prettier, Black, gofmt, rustfmt
   - Test runners: Jest, pytest, Go test, Cargo test
   - Build tools: tsc, webpack, setuptools, cargo

3. **Creates Language-Specific Commands** in `.claude/commands/prp-{lang}/`:
   - `{lang}-create.md` - Language-specific PRP creation
   - `{lang}-execute.md` - Language-specific PRP execution

4. **Generates Language-Specific Templates** in `PRPs/templates/`:
   - `prp_{lang}.md` - Language-specific PRP template with:
     - Language-specific validation commands
     - Framework-specific patterns
     - Common gotchas for the language/framework

## Example Output

### TypeScript Project

Creates:
- `.claude/commands/prp-typescript/ts-create.md`
- `.claude/commands/prp-typescript/ts-execute.md`
- `PRPs/templates/prp_typescript.md`

Template will include:
```yaml
validation_commands:
  syntax: "npm run lint && npm run type-check"
  test: "npm test"
  build: "npm run build"

common_patterns:
  - Use strict TypeScript mode
  - Prefer interfaces over types for object shapes
  - Use async/await over promises

gotchas:
  - "TypeScript strict mode requires explicit types"
  - "ESLint and Prettier can conflict - use eslint-config-prettier"
```

### Python Project

Creates:
- `.claude/commands/prp-python/py-create.md`
- `.claude/commands/prp-python/py-execute.md`
- `PRPs/templates/prp_python.md`

Template will include:
```yaml
validation_commands:
  syntax: "ruff check . && mypy ."
  test: "pytest tests/ -v"
  coverage: "pytest --cov=src tests/"

common_patterns:
  - Use type hints for function signatures
  - Follow PEP 8 style guide
  - Use dataclasses or Pydantic for models

gotchas:
  - "Use uv for dependency management"
  - "Virtual environments are isolated - activate before running"
```

## Implementation Process

1. Detect or use specified project type
2. Scan for available tools (linters, formatters, test runners)
3. Create `.claude/commands/prp-{lang}/` directory
4. Generate language-specific commands with:
   - Tool-specific validation commands
   - Language-specific patterns and conventions
   - Common gotchas from the ecosystem
5. Create `PRPs/templates/prp_{lang}.md` template
6. Display summary of created files and next steps

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

## Next Steps After Setup

1. **Use language-specific commands**:
   ```
   /{lang}-create user authentication
   /{lang}-execute PRPs/user-auth.md
   ```

2. **Customize templates**: Edit `PRPs/templates/prp_{lang}.md` for your project's specific needs

3. **Add framework-specific patterns**: If using a framework (Next.js, FastAPI, etc.), add framework-specific validation and patterns

## Important Notes

- Language-specific commands are **project-specific** (stored in `.claude/commands/`)
- Templates are **project-specific** (stored in `PRPs/templates/`)
- These commands use the same underlying PRP framework, just with language-specific defaults
- You can still use the generic `/prp-create` and `/prp-execute` commands

## Example Workflow

```bash
# 1. Initialize PRP framework
> /prp-init

# 2. Setup language-specific commands
> /prp-lang-setup --type typescript

# 3. Use language-specific command
> /ts-create API endpoint for user registration

# 4. Execute with TypeScript-specific validation
> /ts-execute PRPs/api-endpoint-for-user-registration.md
```

## Additional Guidance

$ARGUMENTS
