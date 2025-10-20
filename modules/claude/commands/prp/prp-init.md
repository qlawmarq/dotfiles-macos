---
description: Initialize PRP directory structure in current project
allowed-tools: Bash, Write, Read, Glob
---

# Initialize PRP Framework

Initialize the Product Requirement Prompt (PRP) framework in the current project.

## What This Command Does

1. Creates `PRPs/` directory structure in the current working directory
2. Copies PRP templates from user-level configuration (`~/.claude/project-template/PRPs/`)
3. Creates necessary subdirectories (`templates/`, `scripts/`, `ai_docs/`, `completed/`)
4. Copies README.md with PRP framework documentation
5. Creates `.gitkeep` files for empty directories

## Directory Structure Created

```
PRPs/
├── templates/          # PRP templates
│   ├── prp_base.md    # Comprehensive implementation template
│   ├── prp_base_JA.md # Japanese version
│   ├── prp_task.md    # Task-specific template
│   └── prp_task_JA.md # Japanese version
├── scripts/
│   └── prp_runner.py  # PRP execution script
├── ai_docs/           # Project-specific documentation
│   └── .gitkeep
├── completed/         # Completed PRPs
│   └── .gitkeep
└── README.md          # PRP framework guide
```

## Usage

Run this command in your project root:

```
/prp-init
```

## What Happens Next

After initialization:

1. **Create a PRP**: Use `/prp-create [feature]` to generate a PRP
2. **Execute a PRP**: Use `/prp-execute PRPs/my-feature.md` to implement it
3. **Add AI docs**: Place library-specific documentation in `PRPs/ai_docs/`
4. **Move completed PRPs**: Finished PRPs go to `PRPs/completed/`

## Implementation Process

1. Check if PRPs/ directory already exists (warn if yes, ask to continue)
2. Create directory structure
3. Copy all templates and scripts from `~/.claude/project-template/PRPs/`
4. Create `.gitkeep` files for empty directories
5. Display success message with next steps

## Important Notes

- This command initializes the PRP framework **for the current project**
- Templates are copied from your user-level Claude Code configuration
- If `PRPs/` already exists, you'll be prompted before overwriting
- After initialization, you can customize templates for this specific project

## Example Workflow

```bash
# 1. Initialize PRP framework
> /prp-init
✓ PRPs directory structure created

# 2. Create your first PRP
> /prp-create user authentication system

# 3. Execute the PRP
> /prp-execute PRPs/user-authentication-system.md

# 4. After completion
PRPs/user-authentication-system.md → PRPs/completed/
```

## Additional Guidance

$ARGUMENTS
