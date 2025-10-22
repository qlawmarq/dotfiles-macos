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
