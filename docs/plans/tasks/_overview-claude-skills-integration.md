# Overall Design Document: Claude Skills Integration

Generation Date: 2025-10-22
Target Plan Document: 20251022-claude-skills-integration.md
Design Document: docs/design/claude-skills-integration.md (Version 1.1 - Approved)

## Project Overview

### Purpose and Goals

Integrate Claude Skills deployment capability into the macOS dotfiles management system, enabling automated deployment of user-level Skills to `~/.claude/skills/` through the existing claude module infrastructure. This extends the current resource deployment pattern (agents, commands, tools, hooks, project-template) to include Skills, ensuring consistent Skills availability across machines.

### Background and Context

The macOS dotfiles system currently deploys agents, commands, tools, hooks, and project-template to `~/.claude/`, but does not support Skills deployment. This integration adds Skills as a new resource type following the established deployment pattern, with specific handling for:
- Skills-specific cleanup warnings (to protect user-created skills)
- Nested directory permissions (skills contain subdirectories with supporting files)
- Example skill template for user guidance

## Task Division Design

### Division Policy

Tasks are divided based on **Horizontal Slice (Layer-based implementation)** approach as specified in Design Doc:
- All skills share the same deployment mechanism
- Changes concentrated in apply.sh and directory structure
- Foundation must be complete before skills can be deployed
- Each task represents one logical file change (1 commit = 1 task)

### Verifiability Level

- **Level 1 (L1)**: Syntax verification (shell script syntax check)
- **Level 2 (L2)**: Unit-level functional verification (individual script functionality)
- **Level 3 (L3)**: Integration verification (E2E deployment testing) - Phase 3 only

### Inter-task Relationship Map

```
Phase 1: Deploy Script Modification
  Task 1.1: Add skills to resource loop
    ↓
  Task 1.2: Update permissions handling
    ↓ (parallel)
  Task 1.3: Add cleanup warning
    ↓ (parallel)
  Task 1.4: Add error logging
    ↓
  Phase 1 Completion Check

Phase 2: Example Skills Creation
  Task 2.1-2.2: Create template-skill (combined)
    ↓
  Phase 2 Completion Check

Phase 3: Integration Testing & Verification
  Task 3.1-3.7: Manual verification tasks (no commits)
    ↓
  All acceptance criteria verified

Final Phase: Quality Assurance
  Complete workflow verification
```

### Task Details

**Phase 1: Deploy Script Modification** (4 commits)
- Task 01: Add `skills` to resource loop (Design Doc Change 1)
- Task 02: Update permissions handling (Design Doc Change 2)
- Task 03: Add cleanup warning (Design Doc Change 3)
- Task 04: Add error logging (Design Doc Change 4)

**Phase 2: Example Skills Creation** (1 commit)
- Task 05: Create template-skill directory and SKILL.md (Design Doc Change 5)

**Phase 3: Integration Testing & Verification** (0 commits)
- Tasks are manual verification only
- All 8 acceptance criteria must be verified
- E2E testing requires Claude Code session

### Interface Change Impact Analysis

| Existing Interface | New Interface | Conversion Required | Corresponding Task |
|-------------------|---------------|-------------------|-------------------|
| Resource loop (agents, commands, tools, hooks, project-template) | Add skills to loop | Extension only | Task 01 |
| Permissions (tools, hooks) | Add skills to permissions | Extension only | Task 02 |
| Cleanup mode (all resources) | Add skills-specific warning | New conditional | Task 03 |
| Copy operation error handling | Add error logging | Enhancement | Task 04 |

### Common Processing Points

- **Shell utilities**: All tasks use existing functions (`print_info`, `print_success`, `print_warning`, `confirm`)
- **Directory operations**: All tasks follow existing `cp -r` and `mkdir -p` patterns
- **Error handling**: All tasks use `|| true` pattern for non-fatal errors
- **CLEANUP_MODE flag**: Shared across all resource types including skills

## Implementation Considerations

### Principles to Maintain Throughout

1. **Pattern Consistency**: Follow existing resource deployment patterns in apply.sh
2. **Non-Breaking Changes**: All changes are additive, no modifications to existing resource deployments
3. **Error Resilience**: Skills deployment failures must not break other resource deployments
4. **User Safety**: Skills-specific cleanup warning protects user-created skills
5. **Atomic Commits**: Each task produces exactly one commit

### Risks and Countermeasures

- **Risk**: Cleanup mode removes user-created skills
  - **Countermeasure**: Task 03 adds explicit cleanup warning with user confirmation

- **Risk**: Permissions not set correctly for nested directories
  - **Countermeasure**: Task 02 uses `find` command instead of glob pattern

- **Risk**: Skills directory creation fails
  - **Countermeasure**: Task 04 adds error logging for visibility

- **Risk**: Skills conflict with commands namespace
  - **Countermeasure**: Skills and commands use different namespaces; documented in template skill (Task 05)

### Impact Scope Management

**Allowed change scope**:
- modules/claude/apply.sh (resource deployment loop, lines 243-266)
- modules/claude/skills/ (new directory creation)
- ~/.claude/skills/ (new deployment target)

**No-change areas**:
- Existing resource deployments (agents, commands, tools, hooks, project-template)
- MCP server configuration
- Claude Desktop config.json generation
- Module dependency resolution system
- Other modules (brew, mise, git, vscode, finder, keyboard, dotfiles)

## Design Document Reference

All implementation details are specified in:
- **Design Document**: /Users/masaki/Codes/dotfiles/docs/design/claude-skills-integration.md
- **Version**: 1.1 (Approved)
- **Acceptance Criteria**: 8 criteria (lines 82-91)
- **File Changes Required**: 5 changes (lines 605-740)
- **Test Strategy**: Lines 417-509

### Key Design Doc Sections

- **File Changes Required**: Lines 605-662 (specific implementation code)
- **Acceptance Criteria**: Lines 82-91 (verification requirements)
- **Test Strategy**: Lines 417-509 (verification procedures)
- **Required Implementation Order**: Lines 377-392 (dependency order)
- **Integration Testing Points**: Lines 395-408 (E2E verification)

## Execution Order

**Recommended execution order** (respecting dependencies):

1. Execute Task 01 (foundation: add skills to loop)
2. Execute Task 02, 03, 04 in any order (parallel safe)
3. Verify Phase 1 completion
4. Execute Task 05 (depends on Phase 1 completion)
5. Verify Phase 2 completion
6. Execute Phase 3 verification tasks (manual testing)
7. Execute Final QA

**Critical dependencies**:
- Task 05 depends on all Phase 1 tasks being complete
- Phase 3 depends on Task 05 being complete
- Final QA depends on all phases being complete

## Overall Optimization Results

### Common Processing

- **Shared utilities**: Reuse existing `lib/utils.sh` functions for all console output
- **Error handling pattern**: Consistent `|| true` usage across all script modifications
- **Permission handling**: Unified approach using `find` command for both tools, hooks, and skills

### Impact Scope Management

- **Boundary**: Changes limited to resource deployment loop (lines 243-266)
- **Isolation**: New skills directory has no impact on existing resource directories
- **Verification**: Each phase has explicit completion criteria

### Implementation Order Optimization

- Phase 1 tasks can execute in parallel after Task 01 completes
- Phase 2 can only start after Phase 1 is complete
- Phase 3 verification can only start after Phase 2 is complete

## Next Steps

1. Review this overview document
2. Execute Phase 1 tasks (Task 01-04) in order
3. Verify Phase 1 completion criteria
4. Execute Phase 2 task (Task 05)
5. Verify Phase 2 completion criteria
6. Execute Phase 3 verification tasks (manual testing)
7. Execute Final QA

## Task File Naming Convention

- `20251022-claude-skills-task-01.md` (Phase 1, Task 1)
- `20251022-claude-skills-task-02.md` (Phase 1, Task 2)
- `20251022-claude-skills-task-03.md` (Phase 1, Task 3)
- `20251022-claude-skills-task-04.md` (Phase 1, Task 4)
- `20251022-claude-skills-phase1-completion.md` (Phase 1 completion marker)
- `20251022-claude-skills-task-05.md` (Phase 2, combined Task 2.1-2.2)
- `20251022-claude-skills-phase2-completion.md` (Phase 2 completion marker)
- Phase 3 tasks are verification only (no task files for commits)
