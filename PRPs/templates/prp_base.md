name: "Shell/Bash PRP Template - macOS dotfiles Project Specialized"
description: |

---

## Goal

**Feature Goal**: [Specific, measurable end state of what needs to be built]

**Deliverable**: [Concrete artifact - new module, configuration script, backup script, etc.]

**Success Definition**: [How you'll know this is complete and working]

## User Persona (if applicable)

**Target User**: [Specific user type - macOS developer, system administrator, etc.]

**Use Case**: [Primary scenario when this feature will be used]

**User Journey**: [Step-by-step flow of how user interacts with this feature]

**Pain Points Addressed**: [Specific user frustrations this feature solves]

## Why

- [Business value and user impact]
- [Integration with existing features]
- [Problems this solves and for whom]

## What

[User-visible behavior and technical requirements]

### Success Criteria

- [ ] [Specific measurable outcomes]

## All Needed Context

### Context Completeness Check

_Before writing this PRP, validate: "If someone knew nothing about this codebase, would they have everything needed to implement this successfully?"_

### Documentation & References

```yaml
# MUST READ - Include these in your context window
- file: CLAUDE.md
  why: Project architecture, module structure, development guidelines
  pattern: Module dependencies, Shell script conventions, configuration file locations

- file: AGENTS.md
  why: Project structure, build/test commands, coding style
  pattern: Bash script conventions, indentation, utility reuse

- file: modules/dependencies.txt
  why: Module dependency definitions
  pattern: How to declare dependencies

- file: lib/utils.sh
  why: Shared utility functions (print_info, success, error, confirm, etc.)
  pattern: Error handling, colored output, macOS checks

- file: lib/defaults.sh
  why: macOS defaults command utilities
  pattern: Hybrid XML/text approach for settings management

- file: modules/{existing_module}/apply.sh
  why: Reference existing module patterns
  pattern: Script structure, error handling, user prompts

# Project-specific documentation
- docfile: [PRPs/ai_docs/shell_patterns.md]
  why: [Shell script best practices]
  section: [Specific section]
```

### Current Codebase tree (run `tree` in the root of the project) to get an overview of the codebase

```bash
# Example: tree -L 2 -a
```

### Desired Codebase tree with files to be added and responsibility of file

```bash
# Example: Adding a new module
modules/
  ├── new_module/
  │   ├── apply.sh         # Configuration apply script
  │   ├── backup.sh        # Backup script (optional)
  │   └── config_files/    # Configuration files (as needed)
```

### Known Gotchas of our codebase & Tool Quirks

```bash
# CRITICAL: Shell scripts use #!/bin/sh for POSIX compatibility
# Don't use Bash-specific features (arrays, [[]], process substitution, etc.)

# CRITICAL: macOS defaults command may require restart
# Example: Finder settings require `killall Finder` after changes

# CRITICAL: Use SCRIPT_DIR and DOTFILES_DIR, not absolute paths
# Example: SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# CRITICAL: Check and backup existing files before creating symlinks
# Example: [ -e "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
```

## Implementation Blueprint

### File Structure and Script Responsibilities

```bash
# New module structure
modules/new_module/
├── apply.sh              # Main apply script
│   - Apply settings
│   - Create symlinks
│   - Configure applications
│   - Restart as needed
│
├── backup.sh            # Backup script (optional)
│   - Save current settings to files
│   - Get system settings with defaults read
│   - Copy configuration files
│
└── config/              # Configuration files (as needed)
    ├── settings.txt     # Human-readable settings
    └── config.xml       # XML format settings (as needed)
```

### Implementation Tasks (ordered by dependencies)

```yaml
Task 1: CREATE modules/{module_name}/ directory
  - EXECUTE: mkdir -p modules/{module_name}
  - PLACEMENT: Inside modules/ directory
  - PERMISSIONS: chmod +x as needed

Task 2: CREATE modules/{module_name}/apply.sh
  - IMPLEMENT: Configuration apply script
  - FOLLOW pattern: modules/{existing_module}/apply.sh
  - REQUIRED elements:
    * shebang: #!/bin/sh
    * SCRIPT_DIR definition
    * source lib/utils.sh
    * macOS check: check_macos
    * error handling: set -e or manual confirmation
    * user feedback: print_info, success, error
  - NAMING: lowercase, underscore-separated
  - PLACEMENT: modules/{module_name}/

Task 3: CREATE modules/{module_name}/backup.sh (optional)
  - IMPLEMENT: Backup script
  - FOLLOW pattern: modules/{existing_module}/backup.sh
  - REQUIRED elements: same structure as apply.sh
  - FUNCTION: Save current settings to files
  - PLACEMENT: modules/{module_name}/

Task 4: UPDATE modules/dependencies.txt
  - ADD: Dependencies for new module
  - FORMAT: {module_name}: {dependency1} {dependency2}
  - EXAMPLE: new_module: brew mise
  - NO dependencies: new_module:

Task 5: CREATE configuration files (as needed)
  - PLACEMENT: modules/{module_name}/config/
  - FORMAT: Human-readable (.txt) or XML as needed
  - PATTERN: Reference existing module config files

Task 6: TEST scripts
  - EXECUTE: bash -n modules/{module_name}/apply.sh
  - SYNTAX check: shellcheck if available
  - MANUAL test: sh modules/{module_name}/apply.sh
  - VERIFY: Expected settings are applied
```

### Implementation Patterns & Key Details

```bash
#!/bin/sh
# CRITICAL: Use /bin/sh for POSIX compatibility

# PATTERN: Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# PATTERN: Source utilities
. "$DOTFILES_DIR/lib/utils.sh"

# PATTERN: macOS check
check_macos

# PATTERN: Display information
print_info "Setting up {module_name}..."

# PATTERN: Error handling
if ! command -v {required_tool} >/dev/null 2>&1; then
    print_error "{required_tool} is not installed"
    confirm "Continue anyway?" || exit 1
fi

# PATTERN: Create symlink
create_symlink() {
    src="$1"
    dest="$2"

    if [ -e "$dest" ]; then
        print_warning "$dest already exists"
        confirm "Backup and replace?" || return
        mv "$dest" "${dest}.backup"
    fi

    ln -sf "$src" "$dest"
    print_success "Created symlink: $dest -> $src"
}

# PATTERN: Using defaults command
# Apply settings
defaults write com.apple.{domain} {key} -bool {value}

# Read settings (used in backup.sh)
defaults read com.apple.{domain} {key} > settings.txt

# PATTERN: Restart application
killall {ApplicationName}

# PATTERN: Success message
print_success "{module_name} setup completed!"
```

### Integration Points

```yaml
DEPENDENCIES:
  - add to: modules/dependencies.txt
  - pattern: "{module_name}: {dependency1} {dependency2}"
  - validate: No circular dependencies

UTILITIES:
  - use from: lib/utils.sh
  - functions: print_info, success, error, warning, confirm, check_macos
  - use from: lib/defaults.sh (for macOS settings)
  - functions: settings management utilities

ROOT_SCRIPTS:
  - integration: apply.sh and backup.sh automatically detect new modules
  - no changes needed: Modules in modules/ are automatically available
```

## Validation Loop

### Level 1: Syntax & Style (Immediate Feedback)

```bash
# Run after each script creation - fix before proceeding

# Syntax check
bash -n modules/{module_name}/apply.sh
bash -n modules/{module_name}/backup.sh

# ShellCheck (if available)
shellcheck modules/{module_name}/apply.sh
shellcheck modules/{module_name}/backup.sh

# Check and set execute permissions
chmod +x modules/{module_name}/apply.sh
chmod +x modules/{module_name}/backup.sh

# Expected: Zero syntax errors, zero ShellCheck warnings
```

### Level 2: Unit Tests (Component Validation)

```bash
# Test module application (dry-run or in safe environment)
sh modules/{module_name}/apply.sh

# Test backup script
sh modules/{module_name}/backup.sh

# Check symlinks
ls -la ~/{expected_symlink}

# Check settings (for macOS defaults)
defaults read com.apple.{domain} {key}

# Expected: Scripts run without errors
# Expected: Symlinks created correctly
# Expected: Settings applied as expected
```

### Level 3: Integration Testing (System Validation)

```bash
# Test full apply flow
sh apply.sh
# Select new module from menu

# Verify dependency resolution
# Check output shows correct dependency order

# Test backup flow
sh backup.sh
# Select new module from menu

# Check configuration files
cat modules/{module_name}/config/{settings_file}

# Verify application behavior
# Open configured application and verify settings

# Expected: Dependencies resolved in correct order
# Expected: All settings applied
# Expected: Backup created successfully
```

### Level 4: Creative & Domain-Specific Validation

```bash
# macOS-specific validation

# Restart Finder (for Finder settings)
killall Finder
# Visually verify settings are applied

# Check System Preferences
# Open System Preferences app and verify settings

# Restart shell (for dotfiles)
exec $SHELL -l
# Verify environment variables, aliases, functions loaded correctly

# Launch application (for app settings)
open -a "{ApplicationName}"
# Verify settings are reflected

# Check Git configuration (for Git module)
git config --list | grep {expected_setting}

# Check Homebrew packages (for Brew module)
brew list | grep {expected_package}

# Check Claude Desktop MCP (for Claude module)
cat "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
tail -f "$HOME/Library/Logs/Claude/mcp*.log"

# Expected: All settings visually confirmed
# Expected: Applications work as expected
```

## Final Validation Checklist

### Technical Validation

- [ ] All 4 validation levels completed successfully
- [ ] No syntax errors: `bash -n modules/{module_name}/*.sh`
- [ ] No ShellCheck warnings: `shellcheck modules/{module_name}/*.sh` (if available)
- [ ] Execute permissions set: `ls -l modules/{module_name}/*.sh`
- [ ] POSIX compatibility verified: No Bash-specific features used

### Feature Validation

- [ ] All success criteria from "What" section met
- [ ] Manual testing successful: `sh modules/{module_name}/apply.sh`
- [ ] Symlinks created correctly
- [ ] macOS settings applied (if applicable)
- [ ] Backup script works (if applicable)
- [ ] Application restart works properly (if applicable)

### Code Quality Validation

- [ ] Follows CLAUDE.md and AGENTS.md guidelines
- [ ] Reuses lib/utils.sh utility functions
- [ ] Follows existing codebase patterns and naming conventions
- [ ] File placement matches desired directory structure
- [ ] Dependencies correctly defined in modules/dependencies.txt
- [ ] Error handling properly implemented

### Documentation & Deployment

- [ ] Scripts have appropriate comments
- [ ] Error messages are clear and understandable
- [ ] README.md updated (for new modules)
- [ ] New environment variables documented (if applicable)

---

## Anti-Patterns to Avoid

- ❌ Don't use #!/bin/bash - use #!/bin/sh for POSIX compatibility
- ❌ Don't use Bash-specific features (arrays, [[]], process substitution, etc.)
- ❌ Don't use hardcoded absolute paths - use SCRIPT_DIR and DOTFILES_DIR
- ❌ Don't re-implement lib/utils.sh utility functions - reuse existing ones
- ❌ Don't overwrite existing files when creating symlinks without checking
- ❌ Don't skip macOS check - use check_macos
- ❌ Don't fail silently without error messages - use print_error
- ❌ Don't perform destructive operations without user confirmation - use confirm
- ❌ Don't depend on other modules without defining in modules/dependencies.txt
- ❌ Don't forget to notify when application restart is required after apply.sh
