# Task: Create template-skill directory and SKILL.md

Metadata:
- Dependencies: Phase 1 complete (all tasks 01-04)
- Provides: Template skill for user guidance and reference implementation
- Size: Small (2 operations: mkdir + file creation)
- Phase: Phase 2 - Example Skills Creation
- Task Number: 2.1-2.2 (Combined)
- Design Doc Reference: Line 663-740 (Change 5)

## Implementation Content

Create the template skill directory structure and SKILL.md file that provides comprehensive guidance for users creating their own skills. This is a combined task that creates both the directory structure (Task 2.1) and the SKILL.md file content (Task 2.2) in a single commit.

The template skill demonstrates:
- Proper SKILL.md frontmatter format (YAML with name and description)
- Skill directory structure with supporting files
- Instructions for creating new skills
- Examples with explanatory comments
- Clear documentation of when Claude should invoke skills

## Target Files

- [ ] modules/claude/skills/template-skill/ (new directory)
- [ ] modules/claude/skills/template-skill/SKILL.md (new file)

## Implementation Steps

### 1. Create directory structure

- [ ] Create modules/claude/skills/ directory if it doesn't exist:
  ```bash
  mkdir -p modules/claude/skills/template-skill
  ```

- [ ] Verify directory created:
  ```bash
  ls -la modules/claude/skills/template-skill/
  # Expected: Directory exists and is empty
  ```

### 2. Create SKILL.md file

- [ ] Create modules/claude/skills/template-skill/SKILL.md with the following content (from Design Doc lines 672-739):

```markdown
---
# SKILL.md Frontmatter Guide:
# - name: Unique identifier in kebab-case (must match directory name)
# - description: Claude reads this to decide when to autonomously invoke this skill
#   Keep it specific and action-oriented (e.g., "Use when user needs to...")
name: template-skill
description: Template for creating new Claude Code skills. Use this when you need to create a new skill.
---

# Template Skill

This is a template for creating new Claude Code skills.

## Instructions

When creating a new skill:

1. Create a new directory in modules/claude/skills/ with a kebab-case name
2. Create SKILL.md with YAML frontmatter containing:
   - name: matches directory name (kebab-case identifier)
   - description: clear explanation of when Claude should autonomously invoke this skill
3. Add instructions in Markdown format below the frontmatter
4. Optionally add supporting files (scripts, templates, reference docs)

## Skill Structure

```
your-skill-name/
├── SKILL.md              # Required: Frontmatter + instructions
├── template.txt          # Optional: Supporting files
└── helper.sh             # Optional: Scripts (will be made executable)
```

## Examples

Example frontmatter with explanatory comments:
```yaml
---
# The name field identifies the skill (must match directory name)
name: example-skill
# The description field is critical - Claude reads it to determine when to invoke
# Make it specific about the trigger conditions or use cases
description: Brief description of what this skill does and when Claude should use it
---
```

Example usage scenarios:
- Scenario 1: [Describe when Claude should invoke this skill]
- Scenario 2: [Another scenario]

## Supporting Files

Skills can include supporting files:
- **Templates**: Reference templates for Claude to use
- **Scripts**: Helper scripts (will be made executable during deployment)
- **Documentation**: Reference documentation or examples

## Tips

- Keep descriptions concise but specific
- Claude reads the description to decide when to invoke
- Provide clear examples of usage scenarios
- Use markdown formatting for readability
- Test skill invocation by making requests that match the description
```

### 3. Verification

- [ ] Verify file created:
  ```bash
  ls -la modules/claude/skills/template-skill/SKILL.md
  # Expected: File exists
  ```

- [ ] Verify YAML frontmatter syntax:
  ```bash
  head -n 10 modules/claude/skills/template-skill/SKILL.md
  # Expected: Valid YAML between --- delimiters with name and description fields
  ```

- [ ] Verify content completeness:
  - [ ] YAML frontmatter with name and description
  - [ ] Explanatory comments in frontmatter (addresses Design Doc Issue-004)
  - [ ] Instructions section
  - [ ] Skill structure section
  - [ ] Examples section with explanatory comments
  - [ ] Supporting files section
  - [ ] Tips section

## Completion Criteria

- [ ] Template skill directory created at modules/claude/skills/template-skill/
- [ ] SKILL.md file created with valid YAML frontmatter
- [ ] YAML frontmatter contains name and description fields
- [ ] Name matches directory name (template-skill)
- [ ] Instructions are clear and comprehensive
- [ ] Examples include explanatory comments (Design Doc Issue-004 fix)
- [ ] All sections present: Instructions, Skill Structure, Examples, Supporting Files, Tips

## Operation Verification (L2: Functional Level)

```bash
# Verify directory structure
ls -la modules/claude/skills/template-skill/SKILL.md
# Expected: File exists with read permissions

# Validate YAML frontmatter
head -n 10 modules/claude/skills/template-skill/SKILL.md | grep -A 7 "^---$"
# Expected: Shows YAML frontmatter with name and description

# Verify frontmatter has comments (Issue-004 fix)
head -n 10 modules/claude/skills/template-skill/SKILL.md | grep "# "
# Expected: Shows explanatory comments in frontmatter

# Count sections
grep "^## " modules/claude/skills/template-skill/SKILL.md
# Expected: Shows all required sections (Instructions, Skill Structure, Examples, Supporting Files, Tips)

# Verify no syntax errors in markdown code blocks
grep -c '```' modules/claude/skills/template-skill/SKILL.md
# Expected: Even number (all code blocks properly closed)
```

## Notes

- **Impact scope**: Creates new files only, no modifications to existing files
- **Rationale**: Template skill provides user guidance and reference implementation
- **Design Doc compliance**: Implements Change 5 exactly as specified (lines 672-739)
- **Issue-004 fix**: Includes explanatory comments in frontmatter examples
- **Constraints**: Must follow SKILL.md format specification from Claude Code documentation
- **Critical**: This is the only example skill being deployed initially (can add more based on user feedback)

## Commit Message Template

```
feat: create template-skill with comprehensive documentation

Create template skill directory and SKILL.md file providing comprehensive
guidance for users creating their own Claude Code skills.

The template skill demonstrates:
- Proper YAML frontmatter format (name and description)
- Skill directory structure with supporting files
- Clear instructions for skill creation
- Examples with explanatory comments (Design Doc Issue-004 fix)
- Tips for effective skill descriptions

Directory structure:
  modules/claude/skills/template-skill/SKILL.md

This template will be deployed to ~/.claude/skills/template-skill/
when users run sh modules/claude/apply.sh.

Related: Phase 2, Task 2.1-2.2 (Combined)
Design Doc: docs/design/claude-skills-integration.md (Change 5, line 663-740)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
