# Task: Add skills-specific cleanup warning

Metadata:
- Dependencies: Task 01 (skills must be in resource loop)
- Provides: User protection against accidental deletion of manually created skills
- Size: Small (1 file, ~10 line addition)
- Phase: Phase 1 - Deploy Script Modification
- Task Number: 1.3
- Design Doc Reference: Line 633-648 (Change 3)

## Implementation Content

Add a skills-specific cleanup warning to protect users from accidentally deleting manually created skills. Unlike other resources that are always repository-managed, users may create their own skills in `~/.claude/skills/`, so cleanup mode requires explicit confirmation before removing existing skills.

This implements a pre-cleanup warning that asks for user confirmation specifically for skills, with the ability to skip skills cleanup while proceeding with cleanup for other resource types.

## Target Files

- [ ] modules/claude/apply.sh (add before cleanup loop, before line 243)

## Implementation Steps

### 1. Locate insertion point

- [ ] Open modules/claude/apply.sh
- [ ] Find the resource deployment loop (starts around line 243)
- [ ] Locate where cleanup mode logic is handled (before the `cp -r` command)
- [ ] Identify appropriate location to add pre-cleanup warning check

### 2. Add cleanup warning logic

- [ ] Add the following code before the cleanup logic in the resource deployment loop:

  ```bash
  # Skills-specific cleanup warning (protect user-created skills)
  if [ "$CLEANUP_MODE" = true ] && [ "$resource_type" = "skills" ] && [ -d "$CLAUDE_CODE_SETTINGS_DIR/skills" ]; then
      print_warning "WARNING: Cleanup will remove ALL skills including any you created manually"
      if ! confirm "Are you sure you want to remove existing skills?"; then
          print_info "Skipping skills cleanup"
          continue  # Skip to next resource type
      fi
  fi
  ```

### 3. Verify integration with existing cleanup logic

- [ ] Ensure the warning appears before any cleanup actions
- [ ] Verify `continue` statement skips to next iteration correctly
- [ ] Confirm existing cleanup logic for other resources is not affected

### 4. Verification

- [ ] Run syntax check: `sh -n modules/claude/apply.sh`
- [ ] Expected: No syntax errors reported
- [ ] Verify `confirm` function is available (defined in lib/utils.sh)
- [ ] Verify `CLEANUP_MODE` variable is used consistently

## Completion Criteria

- [ ] Cleanup warning added before cleanup logic for skills
- [ ] Warning only appears when CLEANUP_MODE=true and skills directory exists
- [ ] User can choose to skip skills cleanup via confirmation prompt
- [ ] Shell script syntax is valid (sh -n passes)
- [ ] Uses existing `print_warning`, `confirm`, and `print_info` utility functions

## Operation Verification (L1: Syntax Level)

```bash
# Verify shell script syntax
sh -n modules/claude/apply.sh
# Expected: No output (syntax valid)

# Verify the cleanup warning code exists
grep -A 5 "Skills-specific cleanup warning" modules/claude/apply.sh
# Expected: Shows the warning logic

# Verify confirm function is available
grep "^confirm()" lib/utils.sh
# Expected: Shows confirm function definition
```

## Notes

- **Impact scope**: Only affects cleanup mode behavior for skills resource type
- **User safety**: Critical protection against accidental deletion of user-created skills
- **Rationale**: Skills are different from other resources because users create them manually
- **Constraints**: Must use `continue` statement to skip to next iteration (preserves other cleanup)
- **Design decision**: Per Design Doc, this is a skills-specific warning because skills may be user-created
- **Existing patterns**: Uses same `confirm` function pattern as other user confirmations in apply.sh

## Commit Message Template

```
feat: add skills-specific cleanup warning for user protection

Add explicit user confirmation before removing skills in cleanup mode.
Unlike other Claude Code resources, users may create their own skills
manually, so cleanup requires explicit confirmation to prevent
accidental deletion.

Changes:
- Add pre-cleanup warning for skills resource type
- Allow users to skip skills cleanup while proceeding with other resources
- Uses existing confirm() utility function

Related: Phase 1, Task 1.3
Design Doc: docs/design/claude-skills-integration.md (Change 3, line 633-648)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
