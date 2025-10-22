# Task: Update permissions handling for nested directories

Metadata:
- Dependencies: Task 01 (skills must be in resource loop)
- Provides: Proper executable permissions for skill scripts in nested directories
- Size: Small (1 file, 5 line modification)
- Phase: Phase 1 - Deploy Script Modification
- Task Number: 1.2
- Design Doc Reference: Line 617-631 (Change 2)

## Implementation Content

Update the executable permissions handling to support nested directory structures in skills. Skills may contain supporting files (scripts, helpers) in subdirectories, requiring a more sophisticated permission-setting approach than the simple glob pattern used for tools and hooks.

Replace the glob-based chmod with a `find` command that recursively locates and sets permissions for .sh and .py files within nested skill directories.

## Target Files

- [x] modules/claude/apply.sh (lines 259-262)

## Implementation Steps

### 1. Locate target section

- [x] Open modules/claude/apply.sh
- [x] Navigate to lines 259-262
- [x] Verify current code:
  ```bash
  if [ "$resource_type" = "tools" ] || [ "$resource_type" = "hooks" ]; then
      chmod +x "$CLAUDE_CODE_SETTINGS_DIR/$resource_type"/*.sh 2>/dev/null || true
      chmod +x "$CLAUDE_CODE_SETTINGS_DIR/$resource_type"/*.py 2>/dev/null || true
  fi
  ```

### 2. Replace permissions handling

- [x] Replace lines 259-262 with:
  ```bash
  if [ "$resource_type" = "tools" ] || [ "$resource_type" = "hooks" ] || [ "$resource_type" = "skills" ]; then
      # Use find to handle nested directory structures (skills may have subdirectories with scripts)
      find "$CLAUDE_CODE_SETTINGS_DIR/$resource_type" -type f \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} \; 2>/dev/null || true
  fi
  ```

### 3. Verification

- [x] Run syntax check: `sh -n modules/claude/apply.sh`
- [x] Expected: No syntax errors reported
- [x] Verify `find` command syntax is correct (proper escaping of parentheses)
- [x] Verify error suppression pattern `2>/dev/null || true` is maintained

## Completion Criteria

- [x] Conditional includes `skills` resource type
- [x] `find` command replaces glob-based chmod for all three resource types
- [x] Shell script syntax is valid (sh -n passes)
- [x] Error handling preserved (2>/dev/null || true)
- [x] Comment explains reason for using find (nested directories)

## Operation Verification (L1: Syntax Level)

```bash
# Verify shell script syntax
sh -n modules/claude/apply.sh
# Expected: No output (syntax valid)

# Verify the change
grep -A 3 "if.*tools.*hooks.*skills" modules/claude/apply.sh
# Expected: Shows updated conditional with find command

# Verify find command syntax (dry run - will fail if no skills deployed yet)
# This just checks the command structure is valid
type find
# Expected: find is /usr/bin/find
```

## Notes

- **Impact scope**: Affects permissions for tools, hooks, and skills
- **Rationale**: Skills can have nested directory structures (e.g., `skill-name/scripts/helper.sh`)
- **Constraints**: Must maintain error suppression pattern to avoid breaking deployment if no scripts exist
- **Critical**: The `find` command uses `-exec chmod +x {} \;` pattern, not `xargs` (avoids issues with spaces in filenames)
- **Why find vs glob**: Glob patterns (`*.sh`) only match files in immediate directory, not subdirectories

## Commit Message Template

```
feat: update permissions handling for nested skill directories

Replace glob-based chmod with find command to support nested directory
structures in skills. Skills may contain supporting files (scripts,
helpers) in subdirectories that need executable permissions.

Changes:
- Add skills to permissions conditional
- Use find command instead of glob pattern for all three resource types
- Maintains error suppression with || true pattern

Related: Phase 1, Task 1.2
Design Doc: docs/design/claude-skills-integration.md (Change 2, line 617-631)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
