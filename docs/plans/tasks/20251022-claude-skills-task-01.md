# Task: Add skills to resource deployment loop

Metadata:
- Dependencies: None (foundation task)
- Provides: Foundation for all skills deployment
- Size: Small (1 file, 1 line change)
- Phase: Phase 1 - Deploy Script Modification
- Task Number: 1.1
- Design Doc Reference: Line 607-614 (Change 1)

## Implementation Content

Add `skills` to the resource deployment loop in modules/claude/apply.sh, enabling skills to be deployed alongside other Claude Code resources (agents, commands, tools, hooks, project-template).

This is the foundation change that enables all subsequent skills-related functionality.

## Target Files

- [ ] modules/claude/apply.sh (line 243)

## Implementation Steps

### 1. Locate target line

- [ ] Open modules/claude/apply.sh
- [ ] Navigate to line 243
- [ ] Verify current line contains: `for resource_type in agents commands tools hooks project-template; do`

### 2. Modify resource loop

- [ ] Change line 243 from:
  ```bash
  for resource_type in agents commands tools hooks project-template; do
  ```

  To:
  ```bash
  for resource_type in agents commands tools hooks project-template skills; do
  ```

### 3. Verification

- [ ] Run syntax check: `sh -n modules/claude/apply.sh`
- [ ] Expected: No syntax errors reported
- [ ] Verify loop will now iterate over skills in addition to existing resources

## Completion Criteria

- [ ] Line 243 modified to include `skills` in resource loop
- [ ] Shell script syntax is valid (sh -n passes)
- [ ] Change follows existing pattern (simple addition to space-separated list)

## Operation Verification (L1: Syntax Level)

```bash
# Verify shell script syntax
sh -n modules/claude/apply.sh
# Expected: No output (syntax valid)

# Verify the change
grep "for resource_type in" modules/claude/apply.sh | grep skills
# Expected: Line shows skills in the resource list
```

## Notes

- **Impact scope**: This change enables skills deployment but doesn't implement it fully yet
- **Dependencies**: Tasks 02, 03, 04 depend on this foundation change
- **Constraints**: Do not modify any other lines in the resource loop
- **Critical**: This is the foundational change - subsequent tasks cannot work without it

## Commit Message Template

```
feat: add skills to Claude Code resource deployment loop

Add skills to the resource deployment loop to enable skills deployment
alongside existing Claude Code resources (agents, commands, tools, hooks,
project-template).

This is the foundation change for Claude Skills integration into the
dotfiles management system.

Related: Phase 1, Task 1.1
Design Doc: docs/design/claude-skills-integration.md (Change 1, line 607-614)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
