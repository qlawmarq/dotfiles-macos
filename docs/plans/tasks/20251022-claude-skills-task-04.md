# Task: Add error logging for copy failures

Metadata:
- Dependencies: Task 01 (skills must be in resource loop)
- Provides: Visibility into deployment failures
- Size: Small (1 file, ~5 line modification)
- Phase: Phase 1 - Deploy Script Modification
- Task Number: 1.4
- Design Doc Reference: Line 650-661 (Change 4)

## Implementation Content

Replace silent failure of copy operations with explicit error logging. Currently, copy failures are suppressed with `2>/dev/null || true`, providing no feedback when files fail to copy. This change adds a warning message when copy operations fail, while still allowing deployment to continue.

This improves operational visibility without changing the non-fatal error handling behavior.

## Target Files

- [x] modules/claude/apply.sh (around line 256)

## Implementation Steps

### 1. Locate target line

- [x] Open modules/claude/apply.sh
- [x] Navigate to the copy operation line (around line 256)
- [x] Verify current line contains:
  ```bash
  cp -r "$resource_dir"/* "$CLAUDE_CODE_SETTINGS_DIR/$resource_type/" 2>/dev/null || true
  ```

### 2. Replace silent failure with logged failure

- [x] Replace the copy operation line with:
  ```bash
  if ! cp -r "$resource_dir"/* "$CLAUDE_CODE_SETTINGS_DIR/$resource_type/" 2>&1; then
      print_warning "Some $resource_type files may not have been copied completely"
  fi
  ```

### 3. Verification

- [x] Run syntax check: `sh -n modules/claude/apply.sh`
- [x] Expected: No syntax errors reported
- [x] Verify `print_warning` function is available (defined in lib/utils.sh)
- [x] Verify error output is redirected to stdout (2>&1) for visibility

## Completion Criteria

- [x] Copy operation wrapped in if statement with error checking
- [x] Warning message displayed when copy fails
- [x] Shell script syntax is valid (sh -n passes)
- [x] Uses existing `print_warning` utility function
- [x] Deployment continues after copy failure (non-fatal error)

## Operation Verification (L1: Syntax Level)

```bash
# Verify shell script syntax
sh -n modules/claude/apply.sh
# Expected: No output (syntax valid)

# Verify the error logging code exists
grep -A 2 "if ! cp -r" modules/claude/apply.sh
# Expected: Shows the new if statement with print_warning

# Verify print_warning function is available
grep "^print_warning()" lib/utils.sh
# Expected: Shows print_warning function definition
```

## Notes

- **Impact scope**: Affects error visibility for all resource types
- **Behavior change**: Failures now logged instead of silent
- **Non-breaking**: Deployment still continues after failures (same as before)
- **Rationale**: Provides operational visibility without changing error handling behavior
- **Design decision**: Uses `2>&1` to redirect stderr to stdout for visibility
- **Critical**: The `if !` pattern inverts the exit code, so failure triggers the warning

## Commit Message Template

```
feat: add error logging for resource copy failures

Replace silent failure pattern with explicit warning messages when
resource copy operations fail. Deployment continues as before, but
users now have visibility into partial failures.

Changes:
- Wrap cp command in if statement with error checking
- Add print_warning call for copy failures
- Redirect stderr to stdout for visibility (2>&1)

This improves operational visibility for all resource types including
skills, agents, commands, tools, hooks, and project-template.

Related: Phase 1, Task 1.4
Design Doc: docs/design/claude-skills-integration.md (Change 4, line 650-661)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
